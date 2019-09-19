import React from "react";
import _ from "lodash";
import BreadCrumb from "./BreadCrumb";
import SearchFilter from "./SearchFilter";
import Menus from "./Menus";
import Chefs from "./Chefs";
import SearchStore from "../stores/search_store";
import Querystring from "querystring";
import "../styles/react_styles.css";

export default class Listings extends React.Component {
  constructor(props) {
    super(props);
    const search = location.search.substring(1);
    const query = Querystring.parse(search);

    this.query = query;
    this.page = 0;

    this.state = {
      isLoading: false,
      location: query.location,
      api_data: {},
      api_fetched: false,
      menus: [],
      chefs: [],
      cusine_type: { tag_ids: ["all"] },
      dietary_type: ["all"],
      price_filter: ["all"],
      geoCode: { lat: null, lng: null },
      mode: this.query.mode || "restaurant",

      // chef filtering
      chefPriceRange: ["all"],
      chefPackageType: ["all"],
      chefEventType: ["all"],
      chefCuisineType: ["all"],

      // chef sort by
      chefSortByNotice: false,
      chefSortByMinimumOrder: false
    }; // initial fetch // restaurant & menu view. restaurant view default.

    this.handleCuisineChange = this.handleCuisineChange.bind(this);
    this.handlePriceChange = this.handlePriceChange.bind(this);
    this.handleDietaryChange = this.handleDietaryChange.bind(this);
    this.handleModeChange = this.handleModeChange.bind(this);
    this.onFetchSearchResult = this.onFetchSearchResult.bind(this);
    this.onLoadMore = this.onLoadMore.bind(this);
    this.filterChefData = this.filterChefData.bind(this);
    this.handleChefPriceRangeChange = this.handleChefPriceRangeChange.bind(
      this
    );
    this.handleChefPackageTypeChange = this.handleChefPackageTypeChange.bind(
      this
    );
    this.handleChefEventTypeChange = this.handleChefEventTypeChange.bind(this);
    this.handleChefCuisineTypeChange = this.handleChefCuisineTypeChange.bind(
      this
    );
    this.handleChefSortByNoticeChange = this.handleChefSortByNoticeChange.bind(
      this
    );
    this.handleChefSortByMinimumOrderChange = this.handleChefSortByMinimumOrderChange.bind(
      this
    );
  }

  componentDidMount() {
    this.setState({ isLoading: true });
    SearchStore.search(this.query);
    this.unsubscribe = SearchStore.listen(this.onFetchSearchResult);
  }

  onLoadMore(e) {
    e.preventDefault();
    // need to fetch more menus
    this.setState({ isLoading: true });
    let params = this.query;
    params.page = this.page + 1;
    SearchStore.search(params);
  }

  handleModeChange(newMode) {
    this.setState({ mode: newMode });
  }

  onFetchSearchResult(result) {
    this.page += 1;
    // check if it's initial fetch or ... load more
    if (this.state.api_fetched === false) {
      this.state.api_fetched = true;
      this.state.api_data = result;
    } else {
      this.state.api_data.menus = this.state.api_data.menus.concat(
        result.menus
      );
      this.state.api_data.chefs = _.uniqWith(
        this.state.api_data.chefs.concat(result.chefs),
        _.isEqual
      );
    }
    this.filterData();
  }

  handleCuisineChange(e, value) {
    this.state.cusine_type = value;
    this.filterData();
    $("#cuisine_type").click();
  }

  handlePriceChange(e, value, i, checked) {
    const priceFilter = this.state.price_filter;

    if (checked && value !== "all") {
      priceFilter[i] = value;
      priceFilter[0] = "";
    } else if (checked && value === "all") {
      priceFilter.splice(0, priceFilter.length);
      priceFilter[0] = "all";
    } else {
      priceFilter[i] = "";

      if (_.compact(priceFilter).length === 0) {
        priceFilter.splice(0, priceFilter.length);
        priceFilter[0] = "all";
      }
    }

    this.state.price_filter = priceFilter;
    this.filterData();
    $("#price").click();
  }

  handleDietaryChange(e, value, i, checked) {
    const dietaryType = this.state.dietary_type;

    if (checked && value !== "all") {
      dietaryType[i] = value;
      dietaryType[0] = "";
    } else if (checked && value === "all") {
      dietaryType.splice(0, dietaryType.length);
      dietaryType[0] = "all";
    } else {
      dietaryType[i] = "";

      if (_.compact(dietaryType).length === 0) {
        dietaryType.splice(0, dietaryType.length);
        dietaryType[0] = "all";
      }
    }

    this.state.dietary_type = dietaryType;
    this.filterData();
    $("#dietary_preferences").click();
  }

  filterData() {
    const { api_data } = this.state;
    if (api_data && api_data.menus.length > 0) {
      let menus = this.state.api_data.menus;
      let filteredData = {};
      if (
        !!this.state.cusine_type ||
        !!this.state.dietary_type.length ||
        !!this.state.price_filter.length
      ) {
        if (
          this.state.cusine_type &&
          this.state.cusine_type.tag_ids[0] !== "all"
        ) {
          menus = _.filter(menus, o => {
            return (
              _.indexOf(
                o.cuisine_type_tag_names,
                this.state.cusine_type.tag_ids
              ) !== -1
            );
          });
        }

        if (
          this.state.dietary_type.length &&
          this.state.dietary_type[0] !== "all"
        ) {
          let dietMenus = [];
          _.each(this.state.dietary_type, dietary_type_item => {
            let result = _.filter(menus, menu => {
              return dietary_type_item === "all"
                ? true
                : _.indexOf(menu.dietary_type_tag_names, dietary_type_item) !==
                    -1;
            });
            if (result.length) {
              dietMenus = dietMenus.concat(result);
            } else {
              console.log("no result for ", dietary_type_item);
            }
          });
          menus = dietMenus.length && dietMenus;
        }

        if (
          this.state.price_filter.length &&
          this.state.price_filter[0] !== "all"
        ) {
          let priceMenus = [];
          _.each(this.state.price_filter, item => {
            if (item) {
              let priceRange = item.split(",");
              let result = _.filter(menus, o => {
                return (
                  parseFloat(o.price) >= parseFloat(priceRange[0]) &&
                  parseFloat(o.price) <= parseFloat(priceRange[1])
                );
              });
              if (result.length) priceMenus = priceMenus.concat(result);
            }
          });
          menus = priceMenus.length && priceMenus;
        }
      }
      this.setState({
        menus: menus,
        chefs: this.state.api_data.chefs,
        isLoading: false
      });
    } else {
      this.setState({ isLoading: false, chefs: this.state.api_data.chefs });
    }
  }

  handleChefPriceRangeChange(value, i, checked) {
    const { chefPriceRange } = this.state;

    if (checked && value !== "all") {
      chefPriceRange[i] = value;
      chefPriceRange[0] = "";
    } else if (checked && value === "all") {
      chefPriceRange.splice(0, chefPriceRange.length);
      chefPriceRange[0] = "all";
    } else {
      chefPriceRange[i] = "";

      if (_.compact(chefPriceRange).length === 0) {
        chefPriceRange.splice(0, chefPriceRange.length);
        chefPriceRange[0] = "all";
      }
    }

    this.state.chefPriceRange = chefPriceRange;
    this.filterChefData();
    // $("#price").click();
  }

  handleChefPackageTypeChange(value, i, checked) {
    const { chefPackageType } = this.state;
    if (checked && value !== "all") {
      chefPackageType[i] = value;
      chefPackageType[0] = "";
    } else if (checked && value === "all") {
      chefPackageType.splice(0, chefPackageType.length);
      chefPackageType[0] = "all";
    } else {
      chefPackageType[i] = "";

      if (_.compact(chefPackageType).length === 0) {
        chefPackageType.splice(0, chefPackageType.length);
        chefPackageType[0] = "all";
      }
    }

    this.state.chefPackageType = chefPackageType;
    this.filterChefData();
    // $("#price").click();
  }

  handleChefEventTypeChange(value, i, checked) {
    const { chefEventType } = this.state;
    if (checked && value !== "all") {
      chefEventType[i] = value;
      chefEventType[0] = "";
    } else if (checked && value === "all") {
      chefEventType.splice(0, chefEventType.length);
      chefEventType[0] = "all";
    } else {
      chefEventType[i] = "";

      if (_.compact(chefEventType).length === 0) {
        chefEventType.splice(0, chefEventType.length);
        chefEventType[0] = "all";
      }
    }

    this.state.chefEventType = chefEventType;
    this.filterChefData();
    // $("#price").click();
  }

  handleChefCuisineTypeChange(value, i, checked) {
    const { chefCuisineType } = this.state;
    if (checked && value !== "all") {
      chefCuisineType[i] = value;
      chefCuisineType[0] = "";
    } else if (checked && value === "all") {
      chefCuisineType.splice(0, chefCuisineType.length);
      chefCuisineType[0] = "all";
    } else {
      chefCuisineType[i] = "";

      if (_.compact(chefCuisineType).length === 0) {
        chefCuisineType.splice(0, chefCuisineType.length);
        chefCuisineType[0] = "all";
      }
    }

    this.state.chefCuisineType = chefCuisineType;
    this.filterChefData();
    // $("#price").click();
  }

  handleChefSortByNoticeChange(checked) {
    this.state.chefSortByNotice = checked;
    this.filterChefData();
  }

  handleChefSortByMinimumOrderChange(checked) {
    this.state.chefSortByMinimumOrder = checked;
    this.filterChefData();
  }

  filterChefData() {
    const { api_data } = this.state;
    if (api_data && api_data.chefs.length > 0) {
      let { chefs } = api_data;

      // filtering by price category
      const {
        chefPriceRange,
        chefPackageType,
        chefEventType,
        chefCuisineType,
        chefSortByNotice,
        chefSortByMinimumOrder
      } = this.state;
      if (chefPriceRange.length > 0 && chefPriceRange[0] !== "all") {
        chefs = chefs.filter(
          chef => chefPriceRange.indexOf(chef.price_category) !== -1
        );
      }

      // filtering by package type
      if (chefPackageType.length > 0 && chefPackageType[0] !== "all") {
        if (
          chefPackageType[2] === "shareables" &&
          chefPackageType[1] !== "individual"
        ) {
          chefs = chefs.filter(chef => chef.shareables);
        } else if (
          chefPackageType[2] !== "shareables" &&
          chefPackageType[1] === "individual"
        ) {
          chefs = chefs.filter(chef => chef.individually_packaged);
        }
      }

      // filtering by event type
      if (chefEventType.length > 0 && chefEventType[0] !== "all") {
        chefs = chefs.filter(
          chef => _.intersection(chef.event_types, chefEventType).length > 0
        );
      }

      // filtering by cuisine type
      if (chefCuisineType.length > 0 && chefCuisineType[0] !== "all") {
        chefs = chefs.filter(
          chef => _.intersection(chef.tag_names, chefCuisineType).length > 0
        );
      }

      // sorting
      if (chefSortByNotice || chefSortByMinimumOrder) {
        const sortFunctions = [];
        if (chefSortByNotice) {
          sortFunctions.push(function(chef) {
            return chef.pre_order_notice_hour;
          });
        }
        if (chefSortByMinimumOrder) {
          sortFunctions.push(function(chef) {
            return parseFloat(chef.pre_order_min_order_amount);
          });
        }
        chefs = _.sortBy(chefs, sortFunctions);
      }

      this.setState({ chefs: chefs });
    }
  }

  render() {
    const { chefs, menus, api_fetched } = this.state;
    const { mode } = this.state;
    console.log("==? chefs", chefs);
    return (
      <div className="listings">
        <BreadCrumb
          mode={mode}
          queryR={this.query.qr}
          queryM={this.query.qm}
          handleFetchSearchResult={this.onFetchSearchResult}
          location={this.state.location}
        />
        <SearchFilter
          mode={mode}
          handleModeChange={this.handleModeChange}
          onDietaryChange={this.handleDietaryChange}
          onPriceChange={this.handlePriceChange}
          onCuisineChange={this.handleCuisineChange}
          onChefPriceChange={this.handleChefPriceRangeChange}
          onChefPackageTypeChange={this.handleChefPackageTypeChange}
          onChefEventTypeChange={this.handleChefEventTypeChange}
          onChefCuisineTypeChange={this.handleChefCuisineTypeChange}
          onChefSortByNoticeChange={this.handleChefSortByNoticeChange}
          onChefSortByMinimumOrderChange={
            this.handleChefSortByMinimumOrderChange
          }
          menus={menus}
          data={this.state}
        />
        {mode === "restaurant" && (
          <Chefs chefs={chefs} api_fetched={api_fetched} />
        )}
        {(mode === "menus" || mode === "map") && (
          <Menus menus={menus} api_fetched={api_fetched} mode={mode} />
        )}
        <div className="container-fluid" style={{ textAlign: "center" }}>
          {menus.length > 0 &&
            (!this.state.isLoading ? (
              <a
                href="#"
                className="btn btn-outline-primary is-colored"
                onClick={this.onLoadMore}
                style={{ width: "30%", marginBottom: 30 }}
              >
                Load More
              </a>
            ) : (
              <div className="sk-folding-cube">
                <div className="sk-cube1 sk-cube" />
                <div className="sk-cube2 sk-cube" />
                <div className="sk-cube4 sk-cube" />
                <div className="sk-cube3 sk-cube" />
              </div>
            ))}
        </div>
      </div>
    );
  }
}

import React from "react";
import _ from "lodash";
import ReactStars from "react-stars";
import immutable from "object-path-immutable";
import classnames from "classnames";
import Like from "./subcomponents/Like";
import SimpleMap from "./subcomponents/MapView";

export default class Menus extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      highlightedItemId: null,
      activeMarkerId: null,
      defaultCenter: null
    };
    this.coordinations = [];
    this.highlightMenuItem = this.highlightMenuItem.bind(this);
    this.handleMapIt = this.handleMapIt.bind(this);
  }

  highlightMenuItem(id) {
    this.setState({ highlightedItemId: id });
  }

  handleHideMarker() {
    this.setState({
      activeMarkerId: null
    });
  }

  handleMapIt(id, longitude, latitude) {
    if (!this.state.activeMarkerId) {
      this.setState({
        activeMarkerId: id,
        defaultCenter: {
          lng: longitude,
          lat: latitude
        }
      });
    } else {
      this.setState({
        activeMarkerId: null,
        defaultCenter: null
      });
    }
  }

  handleLike() {
    /* action to api endpoints*/
  }

  menuContent() {
    let items = [];
    this.coordinations = [];

    _.map(this.props.menus, (item, idx) => {
      this.coordinations.push({
        lat: item.latitude,
        lng: item.longitude,
        url: item.main_thumb_url,
        price: item.price,
        likes: item.likes,
        title: item.name,
        id: idx
      });
      const kname = `col-12 col-md-6 restaurant-grid-item phone-item menu_${
        item.id
      }`;
      items.push(
        <div key={idx} id={`restaurant_${idx}`} className={kname}>
          <a
            href={item.chef_page}
            className={classnames(
              "restaurant",
              this.state.highlightedItemId === idx && "highlighted"
            )}
            target="_blank"
          >
            <figure>
              <div className="restaurant-thumb">
                <Like onClick={this.handleLike.bind(this)} />
                <img
                  src={item.main_image_url}
                  alt={item.name}
                  className="restaurant-img"
                  width="270"
                  height="220"
                />
                <img
                  src={item.chef.logo_url}
                  alt={item.chef.name}
                  className="chef-img"
                />
              </div>
              <figcaption>
                <h5 className="restaurant-title">
                  <span className="chef-name">{item.chef.name}</span> -{" "}
                  {item.name}
                </h5>
                {/* <div className="restaurant-price">{`from $${item.price}/person`}</div> */}
                {item.likes > 0 && (
                  <div className="row align-items-center restaurant-reviews">
                    <div className="col-6 text-nowrap">
                      <span
                        className="restaurant-rating js-rateyo jq-ry-container"
                        readOnly="readonly"
                        style={{
                          width: 91,
                          display: "inline-block",
                          padding: 0
                        }}
                      >
                        <div className="jq-ry-group-wrapper">
                          <div className="jq-ry-normal-group jq-ry-group">
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#a2a5aa"
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#a2a5aa"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#a2a5aa"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#a2a5aa"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#a2a5aa"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                          </div>

                          <div
                            className={
                              "jq-ry-rated-group jq-ry-group" +
                              " wid-" +
                              item.average_rating
                            }
                          >
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#f21400"
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#f21400"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#f21400"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#f21400"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                            <svg
                              width="15px"
                              height="15px"
                              viewBox="0 0 53.97 52.02"
                              fill="#f21400"
                              style={{ marginLeft: 4 }}
                            >
                              <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                            </svg>
                          </div>
                        </div>
                      </span>
                      <span className="restaurant-text">
                        &nbsp; {item.likes}
                        <span className="hidden-lg-down">&nbsp; Reviews</span>
                      </span>
                    </div>
                    <div className="col-6 text-right">
                      <div className="restaurant-distance restaurant-text">{`${
                        item.distance
                      } away`}</div>
                    </div>
                  </div>
                )}
                <div className="restaurant-category">
                  {_.join(item.tag_names, ", ")}
                </div>
                {/* <div className="col-12 text-nowrap">
                    <span className="restaurant-rating js-rateyo jq-ry-container" readOnly="readonly" style={{width: 91, display: 'inline-block', padding: 0}}>
                    <div className="jq-ry-group-wrapper"><div className="jq-ry-normal-group jq-ry-group"><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#a2a5aa"><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#a2a5aa" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg  width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#a2a5aa" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#a2a5aa" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#a2a5aa" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg></div>

                    <div className={'jq-ry-rated-group jq-ry-group' + ' wid-' + item.average_rating}><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#f21400"><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg  width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#f21400" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#f21400" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#f21400" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg><svg width="15px" height="15px" viewBox="0 0 53.97 52.02" fill="#f21400" style={{marginLeft: 4}}><path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" /></svg></div></div></span>
                    <span className="restaurant-text">&nbsp;{item.likes}
                      <span className="hidden-lg-down">&nbsp;Reviews</span>
                    </span>
                  </div>
                  <div className="col-12 text-nowrap">
                    <div className="restaurant-distance restaurant-text">
                      {`${item.distance} away`} <span style={{color: 'blue'}} onClick={(e) => {e.preventDefault()
  e.stopPropagation(); this.handleMapIt(idx, item.longitude, item.latitude)}}>map it</span>
                    </div>
                  </div>
                </div>
                <div className="restaurant-category">{_.join(item.tag_names, ', ')}</div> */}
              </figcaption>
            </figure>
          </a>
        </div>
      );
    });

    return (
      <div className="listview" id="listview">
        <div className="row">{items}</div>
      </div>
    );
  }

  noDataContent() {
    return (
      <div className="row align-items-center justify-content-center ">
        <div className="col-12 col-md-auto sorry">
          <h3 className="mtb-50 mtb-sm-5 title-sorry text-center">
            We're sorry we couldn't find any results.
          </h3>
          <span>Search tips:</span>
          <ol>
            <li>Check that your address is correct.</li>
            <li>
              Try a more broad search term, e.g. instead of "chicken teriyaki",
              try "chicken".
            </li>
            <li>Need help? contact support@justbooked.com.</li>
          </ol>
        </div>
      </div>
    );
  }

  preResult() {
    return (
      <div className="row">
        <div className="col-12 col-md-6 restaurant-grid-item">
          <a className="restaurant black">
            <figure>
              <div className="restaurant-thumb">
                <button
                  type="button"
                  className="restaurant-favorite js-fav-toggle"
                >
                  <span>Save</span>
                </button>
                <img
                  src="data:image/jpeg;base64,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"
                  alt="Cadillac Jenkins"
                  className="restaurant-img"
                  width={270}
                  height={220}
                />
              </div>
              <figcaption>
                <h5 className="restaurant-title">
                  Portuguese chicken and potatoes
                </h5>
                <div className="restaurant-price">from $12.0/person</div>
                <div className="row align-items-center restaurant-reviews">
                  <div className="col-6 text-nowrap">
                    <span
                      className="restaurant-rating js-rateyo jq-ry-container"
                      readOnly="readonly"
                      style={{ width: 91 }}
                    >
                      <div className="jq-ry-group-wrapper">
                        <div className="jq-ry-normal-group jq-ry-group">
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                        <div
                          className="jq-ry-rated-group jq-ry-group"
                          style={{ width: "100%" }}
                        >
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                      </div>
                    </span>
                    <span className="restaurant-text">
                      6<span className="hidden-lg-down">Reviews</span>
                    </span>
                  </div>
                  <div className="col-6 text-right">
                    <div className="restaurant-distance restaurant-text">
                      29.5 km away map it
                    </div>
                  </div>
                </div>
                <div className="restaurant-category">American, Asian</div>
              </figcaption>
            </figure>
          </a>
        </div>
        <div className="col-12 col-md-6 restaurant-grid-item">
          <a className="restaurant black">
            <figure>
              <div className="restaurant-thumb">
                <button
                  type="button"
                  className="restaurant-favorite js-fav-toggle"
                >
                  <span>Save</span>
                </button>
                <img
                  src="data:image/jpeg;base64,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"
                  alt="Mastro Roberto Trattoria & Pizzeria"
                  className="restaurant-img"
                  width={270}
                  height={220}
                />
              </div>
              <figcaption>
                <h5 className="restaurant-title">Honey Sriracha Chicken</h5>
                <div className="restaurant-price">from $15.0/person</div>
                <div className="row align-items-center restaurant-reviews">
                  <div className="col-6 text-nowrap">
                    <span
                      className="restaurant-rating js-rateyo jq-ry-container"
                      readOnly="readonly"
                      style={{ width: 91 }}
                    >
                      <div className="jq-ry-group-wrapper">
                        <div className="jq-ry-normal-group jq-ry-group">
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                        <div
                          className="jq-ry-rated-group jq-ry-group"
                          style={{ width: "100%" }}
                        >
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                      </div>
                    </span>
                    <span className="restaurant-text">
                      5<span className="hidden-lg-down">Reviews</span>
                    </span>
                  </div>
                  <div className="col-6 text-right">
                    <div className="restaurant-distance restaurant-text">
                      0.0 km away>map it
                    </div>
                  </div>
                </div>
                <div className="restaurant-category">Chinese</div>
              </figcaption>
            </figure>
          </a>
        </div>
        <div className="col-12 col-md-6 restaurant-grid-item">
          <a className="restaurant black">
            <figure>
              <div className="restaurant-thumb">
                <button
                  type="button"
                  className="restaurant-favorite js-fav-toggle is-active"
                >
                  <span>Save</span>
                </button>
                <img
                  src="data:image/jpeg;base64,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"
                  alt="LoveChix"
                  className="restaurant-img"
                  width={270}
                  height={220}
                />
              </div>
              <figcaption>
                <h5 className="restaurant-title">Egg Fried Rice</h5>
                <div className="restaurant-price">from $5.0/person</div>
                <div className="row align-items-center restaurant-reviews">
                  <div className="col-6 text-nowrap">
                    <span
                      className="restaurant-rating js-rateyo jq-ry-container"
                      readOnly="readonly"
                      style={{ width: 91 }}
                    >
                      <div className="jq-ry-group-wrapper">
                        <div className="jq-ry-normal-group jq-ry-group">
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#a2a5aa"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                        <div
                          className="jq-ry-rated-group jq-ry-group"
                          style={{ width: "100%" }}
                        >
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                          <svg
                            width="15px"
                            height="15px"
                            viewBox="0 0 53.97 52.02"
                            fill="#f21400"
                            style={{ marginLeft: 4 }}
                          >
                            <path d="M41.73 52a3 3 0 0 0 3.08-2.92 3 3 0 0 0 0-.44l-1.74-15 10.11-11.02a3 3 0 0 0-.18-4.26 3 3 0 0 0-1.43-.73l-14.66-3-7.32-13.1a3 3 0 0 0-5.2 0l-7.33 13.13-14.66 3a3 3 0 0 0-1.61 5L10.92 33.7l-1.74 15A3 3 0 0 0 11.8 52a3 3 0 0 0 1.6-.25L27 45.46l13.59 6.29a3 3 0 0 0 1.14.25z" />
                          </svg>
                        </div>
                      </div>
                    </span>
                    <span className="restaurant-text">
                      4<span className="hidden-lg-down">Reviews</span>
                    </span>
                  </div>
                  <div className="col-6 text-right">
                    <div className="restaurant-distance restaurant-text">
                      0.0 km away map it
                    </div>
                  </div>
                </div>
                <div className="restaurant-category">Asian, Gluten-free</div>
              </figcaption>
            </figure>
          </a>
        </div>
      </div>
    );
  }

  mapView() {
    return (
      <div className="mapview mapview--desktop" id="mapview">
        <SimpleMap
          data={this.coordinations}
          highlightMenuItem={this.highlightMenuItem}
          activeMarkerId={this.state.activeMarkerId}
          defaultCenter={this.state.defaultCenter}
          handleHideMarker={this.handleHideMarker}
        />
      </div>
    );
  }
  render() {
    let content = "";
    let mapContent = "";

    if (this.props.api_fetched == false) {
      // content = this.preResult()
    } else {
      if (this.props.menus.length > 0) {
        content = this.menuContent();
        mapContent = this.mapView();
      } else {
        content = this.noDataContent();
      }
    }

    return (
      <div className="container-fluid menus-view show">
        <div
          className={`${
            this.props.mode === "map" ? "show" : ""
          } venues js-venues`}
        >
          {content}
          {mapContent}
        </div>
      </div>
    );
  }
}

import React, { Component } from 'react'
import GoogleMapReact from 'google-map-react'
import { Transition } from 'react-transition-group'
import classnames from 'classnames'
import ReactStars from 'react-stars'
import _ from 'lodash'
import OutsideClick from 'react-outside-click'
import scrollToElement from 'scroll-to-element'
import queryString from 'query-string'

const ItemDetail = ({ in: inProp, item }) => (
  <Transition in={inProp} timeout={300}>
    {(state) => {
      return (
        <div className={classnames('defaultStyle', state)}>
          <a className="venue-image" href="#" style={{ backgroundImage: `url(${item.url})` }}></a>
          <div className="venue-footer">
            <div className="venue-name">{item.title}</div>            
            <div className="venue-rating">
              <ReactStars
                count={5}
                size={22}
                defaultValue={item.likes}
                color2={'#ff0000'}
                edit={false}
              />
              <div className="venue-wrap">${item.price}</div>
            </div>
          </div>
        </div>
      );
    }}
  </Transition>
);

export class Venue extends Component {
  constructor(props) {
    super(props);
    this.state = { show: false }
    this.handleToggle = this.handleToggle.bind(this)
    this.hide = this.hide.bind(this)
  }
  
  handleToggle(id) {
    if(!this.state.show) {
      document.querySelector(`#listview`).scrollTop = document.querySelector(`#restaurant_${id}`).offsetTop
      scrollToElement(document.querySelector(`#listview`), {
        offset: 0,
        align: id < 3 ? 'top' : 'center',
        ease: 'out-circ',
        duration: 1500
      });
      this.props.highlightMenuItem(id)
    }
    this.setState(({ show }) => ({
      show: !show
    }))
  }

  hide() {
    this.setState({ show: false })
  }
  
  render() {
    const { item, isVisible } = this.props
    const { show } = this.state
    return (
      <OutsideClick onOutsideClick={this.hide}>
        <div className="marker" style={{marginTop: '-50px'}}>
            <div onClick={() => this.handleToggle(item.id)} style={{cursor: 'pointer', width: '70px', height: '30px'}}>
              <img alt="" src="../images/icons/marker-icon.png" draggable="false" className="innerStyle"/>
              <span className="innerText">{`$${parseFloat(item.price).toFixed(2)}`}</span>
            </div>        
          <ItemDetail in={isVisible || !!show} item={item}></ItemDetail>
        </div>
      </OutsideClick>
    );
  }
}

class SimpleMap extends Component {


  render() {
    const { data, zoom, highlightMenuItem, activeMarkerId, defaultCenter } = this.props
    const center = queryString.parse(location.search)

    return (
      <GoogleMapReact
        defaultCenter={defaultCenter || {
          lat: parseFloat(center.lat),
          lng: parseFloat(center.lng)
        }}
        defaultZoom={zoom}
        resetBoundsOnResize={true} 
      >
        {
          _.map(data, (item, id) => {
            return (
            <Venue
              key={id}
              lat={parseFloat(item.lat)}
              lng={parseFloat(item.lng)}
              item={item}
              highlightMenuItem={highlightMenuItem}
              isVisible={id === activeMarkerId}              
            />)
          })
        }        
      </GoogleMapReact>
    );
  }
}

SimpleMap.defaultProps = {
  zoom: 10,
  defaultCenter: null
}

// SimpleMap.propTypes = {
//   data: PropTypes.array,
//   zoom: PropTypes.number,
//   highlightMenuItem: PropTypes.func.isRequired,
//   activeMarkerId: PropTypes.number,
//   defaultCenter: PropTypes.object,
// }

// Venue.propTypes = {
//   text: PropTypes.string,
//   item: PropTypes.object.isRequired,
//   highlightMenuItem: PropTypes.func.isRequired,
//   isVisible: PropTypes.bool
// }

// ItemDetail.propTypes = {
//   in: PropTypes.bool,
//   item: PropTypes.object.isRequired
// }

export default SimpleMap

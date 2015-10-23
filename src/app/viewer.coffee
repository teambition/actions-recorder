
React = require 'react'
Color = require 'color'
Immutable = require 'immutable'
isSafari = require './is-safari'

{div, span, pre} = React.DOM

module.exports = React.createClass
  displayName: 'recorder-viewer'

  propTypes:
    data: React.PropTypes.any
    height: React.PropTypes.number.isRequired

  getInitialState: ->
    path: []

  onKeyClick: (key) ->
    @setState path: @state.path.concat(key)

  onParentKeyClick: (key) ->
    @setState path: @state.path[...-1].concat(key)

  onPathClick: (index) ->
    @setState path: @state.path.slice(0, (index + 1))

  onPathRootClick: ->
    @setState path: []

  renderPath: ->
    div style: @stylePath(),
      div style: @styleKey(), onClick: @onPathRootClick, '/'
      @state.path.map (key, index) =>
        onClick = => @onPathClick index
        span key: key, style: @styleKey(), onClick: onClick, key

  renderParentKeys: ->
    value = @props.data.getIn(@state.path[...-1])
    if @state.path.length > 0 and value? and (value instanceof Immutable.Collection)
      div style: @styleEntries(),
        value.keySeq().map (entry) =>
          onClick = => @onParentKeyClick entry
          div key: entry,
            span style: @styleKey(), onClick: onClick, entry

  renderKeys: ->
    value = @props.data.getIn(@state.path)
    if value? and (value instanceof Immutable.Collection)
      div style: @styleEntries(),
        value.keySeq().map (entry) =>
          onClick = => @onKeyClick entry
          div key: entry, onClick: onClick,
            span style: @styleKey(), entry

  renderValue: ->
    value = @props.data.getIn(@state.path)
    pre style: @styleValue(),
      JSON.stringify value, null, 2

  render: ->
    div style: @styleRoot(),
      @renderPath()
      if @props.data instanceof Immutable.Collection
        div style: @styleTable(),
          @renderParentKeys()
          @renderKeys()
          @renderValue()
      else
        pre style: @styleValue(),
          if @props.data? then @props.data else 'null'

  styleRoot: ->
    flex: 1
    WebkitFlex: 1
    height: @props.height

  styleTable: ->
    display: if isSafari then '-webkit-flex' else 'flex'
    flexDirection: 'row'
    WebkitFlexDirection: 'row'
    flex: 1
    WebkitFlex: 1
    overflowY: 'auto'
    height: (@props.height - 70)

  styleEntries: ->
    width: 'auto'
    height: (@props.height - 70)
    overflowY: 'auto'
    overflowX: 'visible'
    paddingRight: '10px'
    paddingLeft: '10px'
    paddingTop: '60px'
    paddingBottom: '100px'

  stylePath: ->
    margin: '20px 0'

  styleKey: ->
    backgroundColor: Color().hsl(0,0,90,0.2).hslString()
    padding: '0 10px'
    lineHeight: '24px'
    fontSize: '12px'
    display: 'inline-block'
    cursor: 'pointer'
    marginRight: '10px'
    marginBottom: '6px'

  styleValue: ->
    flex: 1
    WebkitFlex: 1
    margin: 0
    overflowY: 'auto'
    height: (@props.height - 70)
    lineHeight: '21px'
    fontSize: '12px'
    fontFamily: 'Menlo, Consolas, Ubuntu Mono, monospace'
    paddingTop: '60px'
    paddingBottom: '100px'
    paddingLeft: '10px'

let React = require('react/addons');

let App = React.createClass({
  render() {
    return <h1>Hello Working</h1>;
  }
})

React.render(<App/>, document.getElementById('example'));

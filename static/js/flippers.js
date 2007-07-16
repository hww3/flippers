dojo.require("dojo.event.*");

function makeInput( form, name, value ) {
  var input = document.createElement( "input" );
  input.name = name;
  input.value = value;
  form.appendChild( input );
  return true;
}

function buildFormHelper( form, prev, data ) {
  var name;
  if( ( typeof data == "object" ) ||
      ( typeof data == "array" ) ) {
    for( prop in data ) {
      name = prev + "[" + prop + "]";
      // recurse
      buildFormHelper( form,
	  name,
	  data[ prop ] );
    }
  } else {
    // literal
    name = prev;
    makeInput( form, name, data );
  }
}

function buildForm( loc, data ) {
  var form = document.createElement( "form" );
  form.action = loc;
  for( prop in data ) {
    buildFormHelper( form, prop, data[prop] );
  }
  return form;
}


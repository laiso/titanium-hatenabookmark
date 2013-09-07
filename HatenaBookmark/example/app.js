// This is a test harness for your module
// You should do something interesting in this harness 
// to test out the module and to provide instructions 
// to users on how to use it by example.

var hatenabookmark = require('so.lai.hatenabookmark');

hatenabookmark.setup({
  consumer : "pIRcU/9ltLCVew==",
  secret : "DlfRZ1UOKI+X2rpzQGw52c8Gh/I="
});

var win = Ti.UI.createWindow({
	backgroundColor:'white'
});

var login = Ti.UI.createButton({title: 'login', top: 0});
login.addEventListener('click', function(){
  hatenabookmark.authorize({
    error: alert
  });
});
win.add(login);

var bookmark = Ti.UI.createButton({title: 'bookmark', top: 50});
bookmark.addEventListener('click', function(){
  Ti.API.log('logged ', hatenabookmark.isLoggedIn);
  hatenabookmark.bookmark({
    url: 'http://example.com/'
  });
});
win.add(bookmark);

win.open();


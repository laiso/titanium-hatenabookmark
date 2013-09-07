var DEFAULT_URL = "http://b.hatena.ne.jp/touch";

var hatenabookmark = require('so.lai.hatenabookmark');
hatenabookmark.setup({
	consumer : "pIRcU/9ltLCVew==",
	secret : "DlfRZ1UOKI+X2rpzQGw52c8Gh/I="
});

function FirstView() {
	var self = Ti.UI.createWindow();
	container = Ti.UI.createWindow();

	// headr
	var bookmarkButton = Ti.UI.createButton({
		title : 'B!'
	});
	container.rightNavButton = bookmarkButton;

	var homeButton = Ti.UI.createButton({
		title : 'home'
	});
	container.leftNavButton = homeButton;

	// content
	var web = Ti.UI.createWebView({
		url : DEFAULT_URL
	});
	container.add(web);

	// footer
	var loginButton = Ti.UI.createButton({
		title : 'login'
	});

	var toolbar = Titanium.UI.iOS.createToolbar({
		items : [loginButton],
		bottom : 0,
		borderTop : true,
		borderBottom : false
	});
	container.add(toolbar);

	var nav = Ti.UI.iPhone.createNavigationGroup({
		window : container
	});
	self.add(nav);

	// events
	bookmarkButton.addEventListener('click', function(e) {
		if(!hatenabookmark.loggedIn){
			hatenabookmark.authorize();
			return;	
		}
		
		hatenabookmark.bookmark({
			url : web.evalJS('document.URL')
		});
	});
	homeButton.addEventListener('click', function(e) {
		web.evalJS('location.href="' + DEFAULT_URL + '"');
	});
	loginButton.addEventListener('click', function(e) {
		hatenabookmark.authorize();
	});

	return self;
}

module.exports = FirstView;

>|js|
var hatenabookmark = require('so.lai.hatenabookmark');

hatenabookmark.setup({
  consumer : '__CONSUMER_KEY__',
  secret : "__CONSUMER_SECRET__"
});

if(!hatenabookmark.loggedIn){ 
  hatenabookmark.authorize();
}else{
  hatenabookmark.bookmark({
    url : 'http://example.com/'
  });
}
||<


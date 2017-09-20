$(document).ready(function() {
  var currentToken;
  $("#deployToken button").click(function() {
      var name = $('#tokenName').val();
      var supply = $('#tokenSupply').val();
      var decimalPlaces = $('#tokenDecimal').val();
      var symbol = $('#tokenSymbol').val();
      // var image = document.querySelector('img').src;
      var image = "https://www.google.com"
      Token.deploy([supply, name, decimalPlaces, symbol, image]).then(function(deployedToken) {
        currentToken = deployedToken;
        $("#deployToken .result").append("<br>Token deployed with address: " + deployedToken.address);
      });
  });
  $("#useToken button").click(function() {
      var address = $('#useToken input').val();
      currentToken = new EmbarkJS.Contract({
        abi: Token.abi,
        address: address
      });
  });
  web3.eth.getAccounts(function(err, accounts) {
    $('#queryBalance input').val(accounts[0]);
  });
  $('#queryBalance button').click(function() {
    var address = $('#queryBalance input').val();
    currentToken.balanceOf(address).then(function(balance) {
      $('#queryBalance .result').html(balance.toString());
    });
  });
  $('#transfer button').click(function() {
    var address = $('#transfer .address').val();
    var num = $('#transfer .num').val();
    currentToken.transfer(address, num).then(function() {
      $('#transfer .result').html('Done!');
    });;
  });
  var thing = "0x90d95469f650a5e98c266f3ad81dea7fef478f89"  
  
  Token.balanceOf(thing).then(function(value){
    console.log(value)
  })
  
});

  function previewFile() {
    var preview = document.querySelector('img');
    var file    = document.querySelector('input[type=file]').files[0];
    var reader  = new FileReader();

    reader.addEventListener("load", function () {
      preview.src = reader.result;
    }, false);

    if (file) {
      reader.readAsDataURL(file);
    }
  }
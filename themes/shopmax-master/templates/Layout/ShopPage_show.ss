<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0"></h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row" id="product">
      <div class="col-md-6">
        <div class="item-entry">

          <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">

          </div>
          
        </div>

      </div>
      <div class="col-md-6">
        <h2 class="text-black mb-5 pb-5" id="title"></h2>
        <p><strong class="text-primary h4 mt-5 pt-5" id="price"></strong></p>
        <div class="mb-5">
          <div class="input-group mb-3" style="max-width: 120px;">
          <div class="input-group-prepend">
            <button class="btn btn-outline-primary js-btn-minus" type="button">&minus;</button>
          </div>
          <input readonly type="text" class="form-control text-center border-danger bg-white" value="1" placeholder="" aria-label="Example text with button addon" aria-describedby="button-addon1" id="quantity">
          <div class="input-group-append">
            <button class="btn btn-outline-primary js-btn-plus" type="button">&plus;</button>
          </div>
        </div>

        </div>
        <p><a href="#" id="addToCart" class="buy-now btn btn-sm height-auto px-4 py-3 btn-primary">Add To Cart</a></p>

      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();

    let id = (window.location.pathname).split('/');
    id = id[id.length -1];

    //products = await JSON.parse(localStorage.getItem("Products"));
    let products = [];
    $.get({
      url: `customer-api/merchant/${id}`,
      headers:{
        ClientID: "61f0d060f1f163.13349246"
      },
      success: async (res)=>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);

        console.log(responseJSON);
        products = responseJSON.data;
      },
      error: (res) => {
        alert(JSON.parse(res.responseText).message);
      }
    }).always(function(res){
      console.log(res);
    })

    //let product = await products.find(i => i.ID == id);
    //console.log(product);
    if(products){
      $("#title").text(product.Title);
      $("#price").text("Rp "+ new Intl.NumberFormat("id-ID").format(product.Price) );

      if(product.Images){
        $("#carouselExampleIndicators").html(`
          <ol class="carousel-indicators">
            ${(product.Images).map((item, index)=>{
              return (`
                <li data-target="#carouselExampleIndicators" data-slide-to="${index}"  ></li>
              `);
            }).join('')}
            
          </ol>
          <div class="carousel-inner product- md-height bg-gray d-block">
            ${(product.Images).map((item, index) =>{
              return (`
                <div class="carousel-item ${index == 0 ? 'active' : ''}">
                  <img src="${item.Link}" class="d-block w-100" alt="...">
                </div>
              `)
            }).join('')}
            
          </div>
          <a class="carousel-control-prev" type="button" data-target="#carouselExampleIndicators" data-slide="prev">
            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
          </a>
          <a class="carousel-control-next" type="button" data-target="#carouselExampleIndicators" data-slide="next">
            <span class="carousel-control-next-icon" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
          </a>
        `);
      }else{
        $("#carouselExampleIndicators").html(`
          <div class="text-center">
            <h1>Image Not Found</h1>
          </div>
        `)
      }
    }else{
      alert('Product Not Found');
      window.history.back();
    }

    spinner.hide();
    

    $("#addToCart").click(function (e){
      e.preventDefault();
      const AccessToken = sessionStorage.getItem("AccessToken");
      if(!AccessToken){
        alert("Please login first to continue");
      }else{
        console.log("anu");
        spinner.show();
        const quantity =  $("#quantity").val();
        const settings = {
          "url": `customer-api/addToCart/${id}`,
          "method": "POST",
          "headers": {
            "ClientID": "61f0d060f1f163.13349246",
            "AccessToken" : AccessToken
          },
          "data": {
            "quantity" : quantity,
          },
          "success": (res) => {
            let response = JSON.parse(res);
            alert(response.message);
            window.location.reload();
          },
          "error": (res) => {
            alert(JSON.parse(res.responseText).message);
          }
        }

        $.ajax(settings).always(function (res) {
          console.log(res);
          spinner.hide();
        });
      }
      
    })
  })
</script>
<style>
  
  .not-avail{
    position: absolute;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
  }
  .i-cart{
    display: none;
  }
  @media only screen and (max-width: 600px){
    .not-avail{
      left: 1%;
      top: 20%;
      transform: unset;
    }
    .inp-cart{
      display: none;
    }
    .i-cart{
      display: block;
    }
  }
</style>

<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="merchant-title"></h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container" id="products">

  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();

    let id = (window.location.pathname).split('/');
    id = id[id.length -1];

    let merchant = {};
    let products = [];
    await $.get({
      url: `customer-api/merchant/${id}`,
      headers:{
        ClientID: "61f0d060f1f163.13349246"
      },
      success: async (res)=>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        merchant = await responseJSON.data;
        products = await merchant.Products;
        
        $('#merchant-title').html(`${merchant.Name} &#8226 ${merchant.Category}`);

        await products.forEach((item, index) => {
          $('#products').append(`
            <div class="row">
              <div class="col-md-6 col-5">
                <div class="item-entry">

                  <div id="carouselExampleIndicators" class="carousel slide" data-ride="carousel">
                    ${item.Images ? `
                      <ol class="carousel-indicators">
                        ${(item.Images).map((item, index)=>{
                          return (`
                            <li data-target="#carouselExampleIndicators" data-slide-to="${index}"  ></li>
                          `);
                        }).join('')}
                        
                      </ol>
                      <div class="carousel-inner product- md-height bg-gray d-block">
                        ${(item.Images).map((i, index) =>{
                          return (`
                            <div class="carousel-item ${index == 0 ? 'active' : ''}">
                              <img src="${i.Link}" class="d-block w-100" alt="..." ${item.IsAvailable == 'no' ? 'style="opacity: 0.2;"' : ''}>
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

                      ${item.IsAvailable == 'no' ? `
                        <div class="text-center not-avail">
                          <svg xmlns="http://www.w3.org/2000/svg" width="30" height="30" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16">
                            <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                            <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
                          </svg>
                          <br/>
                          <p>Product not available</p>
                        </div>
                      ` : ''}

                    ` : `
                      <div class="text-center">
                        <h3>Image Not Found</h3>
                      </div>
                    `}
                  </div>
                  
                </div>

              </div>
              <div class="col-md-4 col-5">
                <h4 class="text-black mb-3">${item.Title}</h4>
                <p><strong class="${item.IsAvailable == 'yes' ? 'text-primary' : 'text-secondary'} h4 mt-5 pt-5">${"Rp "+ new Intl.NumberFormat("id-ID").format(item.Price) }</strong></p>
              </div>
              <div class="col-md-2 col-2 inp-cart">
                <div class="mb-3">
                  <div class="input-group" style="width: 110px;">
                  <div class="input-group-prepend">
                    <button class="btn ${item.IsAvailable == 'yes' ? 'btn-outline-primary js-btn-minus' : 'btn-outline-secondary disabled'}" type="button">&minus;</button>
                  </div>
                  <input readonly type="text" class="form-control text-center bg-white ${item.IsAvailable == 'yes' ? 'border-danger' : 'border-secondary'}" value="1" placeholder="" aria-label="Example text with button addon" aria-describedby="button-addon1" id="quantity-${item.ID}">
                  <div class="input-group-append">
                    <button class="btn ${item.IsAvailable == 'yes' ? 'btn-outline-primary js-btn-plus' : 'btn-outline-secondary disabled'}" type="button">&plus;</button>
                  </div>
                </div>

                </div>
                <a href="#" data-id="${item.ID}" merchantID="${item.MerchantID}" class="addToCart buy-now btn btn-sm height-auto py-2 ${item.IsAvailable == 'yes' ? 'btn-primary' : 'btn-secondary disabled'}" style="width: 110px;">Add To Cart</a>

              </div>
              <a href="#" data-id="${item.ID}" merchantID="${item.MerchantID}" class="col i-cart ${item.IsAvailable == 'yes' ? 'text-primary' : 'text-secondary disabled'} addToCart"><i class="bi bi-bag-plus-fill"></i></a>
            </div>
            <hr\>
          `)
        })
      },
      error: (res) => {
        alert(JSON.parse(res.responseText).message);
        window.history.back();
      }
    }).always(function(res){
      console.log(res);
    })

    spinner.hide();

    $(".addToCart").click(async function (e){
      e.preventDefault();
      let carts = await JSON.parse(sessionStorage.getItem('cart'));
      const AccessToken = sessionStorage.getItem("AccessToken");
      if(!AccessToken){
        alert("Please login first to continue");
      }else{
        spinner.show();
        if(carts && carts.length > 0 && carts[0].Product.MerchantID != $(this).attr('merchantID')){
          let cek = confirm("Do you want to change orders from this merchant? It's okay, but we delete orders from the previous merchant, okay?");

          if(cek){
            $.get({
              url: 'customer-api/deleteAllCart',
              headers: {
                "ClientID": "61f0d060f1f163.13349246",
                "AccessToken" : AccessToken
              },
              success: () =>{
                $('#cartCount').text(0);

                const idProduct = Number($(this).data('id'));
                const quantity =  $(`#quantity-${idProduct}`).val();
                const settings = {
                  "url": `customer-api/addToCart/${idProduct}`,
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
                    sessionStorage.setItem('cart', JSON.stringify(response.data));
                    $('#cartCount').text(Number($('#cartCount').text()) + 1)
                  },
                  "error": (res) => {
                    alert(JSON.parse(res.responseText).message);
                  }
                }

                $.ajax(settings).always(function (res) {
                  console.log(res);
                });
              },
              error: (res) => {
                alert(JSON.parse(res.responseText).message);
              }
            })
          }
        }else{
          spinner.show();
          const idProduct = Number($(this).data('id'));
          const quantity =  $(`#quantity-${idProduct}`).val();
          const settings = {
            "url": `customer-api/addToCart/${idProduct}`,
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
              $('#cartCount').text(Number($('#cartCount').text()) + 1)
            },
            "error": (res) => {
              alert(JSON.parse(res.responseText).message);
            }
          }

          $.ajax(settings).always(function (res) {
            console.log(res);
          });
        }
        
        spinner.hide();
        
      }
      
    })

    $('.js-btn-minus').on('click', function(e){
			e.preventDefault();
			if ( $(this).closest('.input-group').find('.form-control').val() != 1  ) {
				$(this).closest('.input-group').find('.form-control').val(parseInt($(this).closest('.input-group').find('.form-control').val()) - 1);
			} else {
				$(this).closest('.input-group').find('.form-control').val(parseInt(1));
			}
		});
		$('.js-btn-plus').on('click', function(e){
			e.preventDefault();
			$(this).closest('.input-group').find('.form-control').val(parseInt($(this).closest('.input-group').find('.form-control').val()) + 1);
		});

    
  })

  
</script>
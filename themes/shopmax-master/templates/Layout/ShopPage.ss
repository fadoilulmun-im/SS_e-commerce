<div class="site-blocks-cover inner-page" data-aos="fade">
  <div class="container">
    <div class="row">
      <div class="col-md-6 ml-auto order-md-2 align-self-start">
        <div class="site-block-cover-content">
        <h2 class="sub-title">#New Summer Collection 2019</h2>
        <h1>Arrivals Sales</h1>
        <p><a href="#" class="btn btn-black rounded-0">Shop Now</a></p>
        </div>
      </div>
      <div class="col-md-6 order-1 align-self-end">
        <img src="$ThemeDir/images/model_4.png" alt="Image" class="img-fluid">
      </div>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">

    <div class="row mb-5">
      <div class="col-md-9 order-1">

        <div class="row align">
          <div class="col-md-12 mb-5">
            <div class="float-md-left"><h2 class="text-black h5">Shop All</h2></div>
            <div class="d-flex">
              <div class="dropdown mr-1 ml-md-auto">
                <button type="button" class="btn btn-white btn-sm dropdown-toggle px-4" id="dropdownMenuOffset" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                  Latest
                </button>
                <div class="dropdown-menu" aria-labelledby="dropdownMenuOffset">
                  <a class="dropdown-item" href="#">Men</a>
                  <a class="dropdown-item" href="#">Women</a>
                  <a class="dropdown-item" href="#">Children</a>
                </div>
              </div>
              <div class="btn-group">
                <button type="button" class="btn btn-white btn-sm dropdown-toggle px-4" id="dropdownMenuReference" data-toggle="dropdown">Reference</button>
                <div class="dropdown-menu" aria-labelledby="dropdownMenuReference">
                  <a class="dropdown-item" href="#">Relevance</a>
                  <a class="dropdown-item" href="#">Name, A to Z</a>
                  <a class="dropdown-item" href="#">Name, Z to A</a>
                  <div class="dropdown-divider"></div>
                  <a class="dropdown-item" href="#">Price, low to high</a>
                  <a class="dropdown-item" href="#">Price, high to low</a>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="row mb-5" id="list-product">

        </div>
        <div class="row">
          <div class="col-md-12 text-center">
            <div class="site-block-27">
              <ul>
                <li><a href="#">&lt;</a></li>
                <li class="active"><span>1</span></li>
                <li><a href="#">2</a></li>
                <li><a href="#">3</a></li>
                <li><a href="#">4</a></li>
                <li><a href="#">5</a></li>
                <li><a href="#">&gt;</a></li>
              </ul>
            </div>
          </div>
        </div>
      </div>

      <div class="col-md-3 order-2 mb-5 mb-md-0">
        <div class="border p-4 rounded mb-4">
          <h3 class="mb-3 h6 text-uppercase text-black d-block">Categories</h3>
          <ul class="list-unstyled mb-0">
            <li class="mb-1"><a href="#" class="d-flex"><span>Men</span> <span class="text-black ml-auto">(2,220)</span></a></li>
            <li class="mb-1"><a href="#" class="d-flex"><span>Women</span> <span class="text-black ml-auto">(2,550)</span></a></li>
            <li class="mb-1"><a href="#" class="d-flex"><span>Children</span> <span class="text-black ml-auto">(2,124)</span></a></li>
          </ul>
        </div>

        <div class="border p-4 rounded mb-4">
          <div class="mb-4">
            <h3 class="mb-3 h6 text-uppercase text-black d-block">Filter by Price</h3>
            <div id="slider-range" class="border-primary"></div>
            <input type="text" name="text" id="amount" class="form-control border-0 pl-0 bg-white" disabled="" />
          </div>

          <div class="mb-4">
            <h3 class="mb-3 h6 text-uppercase text-black d-block">Size</h3>
            <label for="s_sm" class="d-flex">
              <input type="checkbox" id="s_sm" class="mr-2 mt-1"> <span class="text-black">Small (2,319)</span>
            </label>
            <label for="s_md" class="d-flex">
              <input type="checkbox" id="s_md" class="mr-2 mt-1"> <span class="text-black">Medium (1,282)</span>
            </label>
            <label for="s_lg" class="d-flex">
              <input type="checkbox" id="s_lg" class="mr-2 mt-1"> <span class="text-black">Large (1,392)</span>
            </label>
          </div>

          <div class="mb-4">
            <h3 class="mb-3 h6 text-uppercase text-black d-block">Color</h3>
            <a href="#" class="d-flex color-item align-items-center" >
              <span class="bg-danger color d-inline-block rounded-circle mr-2"></span> <span class="text-black">Red (2,429)</span>
            </a>
            <a href="#" class="d-flex color-item align-items-center" >
              <span class="bg-success color d-inline-block rounded-circle mr-2"></span> <span class="text-black">Green (2,298)</span>
            </a>
            <a href="#" class="d-flex color-item align-items-center" >
              <span class="bg-info color d-inline-block rounded-circle mr-2"></span> <span class="text-black">Blue (1,075)</span>
            </a>
            <a href="#" class="d-flex color-item align-items-center" >
              <span class="bg-primary color d-inline-block rounded-circle mr-2"></span> <span class="text-black">Purple (1,075)</span>
            </a>
          </div>

        </div>
      </div>
    </div>

  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();
    let products = [];
    let merchants = [];
    var settings = {
      //url: "product-api",
      url: "customer-api/allMerchant",
      "headers": {
        "ClientID": "61f0d060f1f163.13349246"
      },
      "success": async (res) => {
        /*try{
          let response = await JSON.parse(res);
          await localStorage.setItem("Products",JSON.stringify(response.data));
          products = await response.data;
        }catch(e){
          products = await JSON.parse(localStorage.getItem("Products"));
          console.log('error : ',e);
        }*/
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);

        console.log(responseJSON);
        merchants = responseJSON.data;
        
      },
      "error": (res) => {
        alert(JSON.parse(res.responseText).message);
      }
    };

    await $.get(settings).always(function (res) {
      console.log(res);
    });

    spinner.hide();

    const rupiah = (number)=>{
      return new Intl.NumberFormat("id-ID").format(number);
    }

    merchants.forEach((item, index)=>{
      $("#list-product").append(`
        <div class="col-lg-6 col-md-6 item-entry mb-4">
          <a  ${item.IsOpen ? `href="shop/show/${item.ID}"`  : `onclick='alert("Product not available")'`} class="product-item md-height text-danger bg-gray d-block">

            <img src="${item.Photo ? item.Photo : '$ThemeDir/images/prod_2.png'}" alt="Image" class="img-fluid" ${item.IsOpen ? '' :'style="opacity: 0.2;"'}>
            
            ${item.IsOpen ? 
              ``
            :`<div class="text-center" style="position: absolute;top: 50%;left: 50%;transform: translate(-50%, -50%);">
              <svg xmlns="http://www.w3.org/2000/svg" width="40" height="40" fill="currentColor" class="bi bi-x-square" viewBox="0 0 16 16">
                <path d="M14 1a1 1 0 0 1 1 1v12a1 1 0 0 1-1 1H2a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1h12zM2 0a2 2 0 0 0-2 2v12a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V2a2 2 0 0 0-2-2H2z"/>
                <path d="M4.646 4.646a.5.5 0 0 1 .708 0L8 7.293l2.646-2.647a.5.5 0 0 1 .708.708L8.707 8l2.647 2.646a.5.5 0 0 1-.708.708L8 8.707l-2.646 2.647a.5.5 0 0 1-.708-.708L7.293 8 4.646 5.354a.5.5 0 0 1 0-.708z"/>
              </svg>
              <br/>
              <br/>
              <h4>This merchant closed</h4>
            </div>`}
            
          </a>
          <h2 class="item-title"><a ${item.IsOpen ? `href="shop/show/${item.ID}"` :  `onclick='alert("Product not available")'`} >${item.Name}</a></h2>
          <strong class="item-price">${item.Category}</strong>
        </div>
      `)
    })
    
  })
</script>
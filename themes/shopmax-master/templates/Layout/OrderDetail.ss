<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">Order Detail</h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row mb-5">
      <form class="col-md-12" method="post">
        <div class="site-blocks-table">
          <table class="table table-bordered">
            <thead>
              <tr>
                <th class="product-thumbnail">Image</th>
                <th class="product-name">Product</th>
                <th class="product-price">Price</th>
                <th class="product-quantity">Quantity</th>
                <th class="product-total">Total</th>
              </tr>
            </thead>
            <tbody id="lists-product">
              
            </tbody>
          </table>
        </div>
      </form>
    </div>

    <div class="row">
      <div class="col-md-6">
        <div class="row">
          <div class="col-md-7">
            <div class="row">
              <div class="col-md-12 text-center border-bottom mb-5">
                <h3 class="text-black h4 text-uppercase" id="total">Total : Rp 0</h3>
              </div>
            </div>

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

    const AccessToken = sessionStorage.getItem("AccessToken");
    if(!AccessToken){
      alert("Please login first to continue");
      window.history.back();
    }
    let id = (window.location.pathname).split('/');
    id = id[id.length -1];

    await $.get({
      url: `customer-api/orderDetail/${id}`,
      headers: {
        ClientID: "61f0d060f1f163.13349246",
        AccessToken : AccessToken
      },
      success: async (res)=>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        let data = await responseJSON.data;

        $('#total').text(`
          Total : Rp ${new Intl.NumberFormat("id-ID").format(data.TotalPrice)}
        `)

        data.OrderDetails.forEach((item, index)=>{
          $('#lists-product').append(`
            <tr>
              <td class="product-thumbnail">
                <img src="${item.Product.Images ? item.Product.Images[0].Link : ''}" alt="Image" class="img-fluid">
              </td>
              <td class="product-name">
                <h2 class="h5 text-black">${item.Product.Title}</h2>
              </td>
              <td id="price-${item.Product.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.Product.Price)}</td>
              <td>
                ${item.Quantity}
              </td>
              <td id="total-price-${item.Product.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.TotalPrice)}</td>
            </tr>
          `)
        })
        
      },
      error: (res) => {
        alert(JSON.parse(res.responseText).message);
        window.history.back();
      }
    }).always(function(res){})
  })
</script>
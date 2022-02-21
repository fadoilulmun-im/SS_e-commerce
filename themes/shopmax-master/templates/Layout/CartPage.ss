<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">$title</h3>
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
                <th class="product-remove">Remove</th>
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
          <div class="col-md-12">
            <label class="text-black h4" for="coupon">Coupon</label>
            <p>Enter your coupon code if you have one.</p>
          </div>
          <div class="col-md-8 mb-3 mb-md-0">
            <input type="text" class="form-control py-3" id="coupon" placeholder="Coupon Code">
          </div>
          <div class="col-md-4">
            <button class="btn btn-primary btn-sm px-4">Apply Coupon</button>
          </div>
        </div>
      </div>
      <div class="col-md-6 pl-5">
        <div class="row justify-content-end">
          <div class="col-md-7">
            <div class="row">
              <div class="col-md-12 text-center border-bottom mb-5">
                <h3 class="text-black h4 text-uppercase">Cart Totals</h3>
              </div>
            </div>
            <div class="row mb-3">
              <div class="col-md-6">
                <span class="text-black">Subtotal</span>
              </div>
              <div class="col-md-6 text-right">
                <strong class="text-black" id="subtotal">$230.00</strong>
              </div>
            </div>
            <div class="row mb-5">
              <div class="col-md-6">
                <span class="text-black">Total</span>
              </div>
              <div class="col-md-6 text-right">
                <strong class="text-black" id="total">$230.00</strong>
              </div>
            </div>

            <div class="row">
              <div class="col-md-12">
                <button class="btn btn-primary btn-lg btn-block" id="checkout">Proceed To Checkout</button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(async ()=>{
    var spinner = $('#loader');
    let total = 0;

    spinner.show();
    const AccessToken = sessionStorage.getItem("AccessToken");
    if(!AccessToken){
      await Swal.fire({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 2000,
        timerProgressBar: true,
        didOpen: (toast) => {
          toast.addEventListener('mouseenter', Swal.stopTimer)
          toast.addEventListener('mouseleave', Swal.resumeTimer)
        },
        icon: 'error',
        title: "Please login first to continue"
      });
      window.history.back();
    }else{
      let cart = [];
      await $.get({
        url : 'customer-api/listCart',
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        success: async (res)=>{
          let response = res.split('[2022-');
          let responseJSON = JSON.parse(response[0]);
          cart = await responseJSON.data;

          cart.forEach((item, index)=>{
            total += item.TotalPrice;
            $("#lists-product").append(`
              <tr>
                <td class="product-thumbnail">
                  <img src="${item.Product.Images ? item.Product.Images[0].Link : ''}" alt="Image" class="img-fluid">
                </td>
                <td class="product-name">
                  <h2 class="h5 text-black">${item.Product.Title}</h2>
                </td>
                <td id="price-${item.Product.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.Product.Price)}</td>
                <td>
                  <div class="input-group mx-auto" style="width: 110px;">
                    <div class="input-group-prepend">
                      <button data-id="${item.Product.ID}" class="btn btn-outline-primary js-btn-minus" type="button">&minus;</button>
                    </div>
                    <input type="text" class="form-control text-center border-danger bg-white" readonly value="${item.Quantity}" placeholder="" aria-label="Example text with button addon" aria-describedby="button-addon1">
                    <div class="input-group-append">
                      <button data-id="${item.Product.ID}" class="btn btn-outline-primary js-btn-plus" type="button">&plus;</button>
                    </div>
                  </div>

                </td>
                <td id="total-price-${item.Product.ID}">Rp ${new Intl.NumberFormat("id-ID").format(item.TotalPrice)}</td>
                <td><a href="#" id="deleteFromCart-${item.ID}" class="btn btn-primary height-auto btn-sm">X</a></td>
              </tr>
            `)

            $(`#deleteFromCart-${item.ID}`).click(function(e){
              e.preventDefault();
              let yes = confirm("Are you sure, to delete it ?");
              if(yes){
                $.get({
                  url: `customer-api/deleteFromCart/${item.Product.ID}`,
                  headers: {
                    "ClientID": "61f0d060f1f163.13349246",
                    "AccessToken" : AccessToken
                  },
                  success: async (res)=>{
                    $(this).parent().parent().hide();
                    $('#cartCount').text(Number($('#cartCount').text()) - 1);

                    total -= (JSON.parse(res)).data.TotalPrice;
                    $('#total').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
                    $('#subtotal').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
                  },
                  error: (res) => {
                    Swal.fire({
                      toast: true,
                      position: 'top-end',
                      showConfirmButton: false,
                      timer: 2000,
                      timerProgressBar: true,
                      didOpen: (toast) => {
                        toast.addEventListener('mouseenter', Swal.stopTimer)
                        toast.addEventListener('mouseleave', Swal.resumeTimer)
                      },
                      icon: 'error',
                      title: JSON.parse(res.responseText).message
                    });
                  }
                })
              }
            })
          })
          
          $('#total').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
          $('#subtotal').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
        },
        error: async (res) => {
          await Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
              toast.addEventListener('mouseenter', Swal.stopTimer)
              toast.addEventListener('mouseleave', Swal.resumeTimer)
            },
            icon: 'error',
            title: JSON.parse(res.responseText).message
          });
          window.history.back();
        }
      }).always(function(res){
        spinner.hide();
      })

      
    }

    $('.js-btn-minus').on('click', async function(e){
			e.preventDefault();
			if ( $(this).closest('.input-group').find('.form-control').val() != 1  ) {
        $(this).closest('.input-group').find('.form-control').val(parseInt($(this).closest('.input-group').find('.form-control').val()) - 1);

        $.post({
          url: `customer-api/updateInCart/${Number($(this).data('id'))}`,
          headers: {
            ClientID: "61f0d060f1f163.13349246",
            AccessToken : AccessToken
          },
          data: {
            quantity : parseInt($(this).closest('.input-group').find('.form-control').val()),
          },
          success: async (res) =>{
            let response = res.split('[2022-');
            let responseJSON = JSON.parse(response[0]);
            let cart = responseJSON.data;
            console.log(cart);
            total -= cart.Product.Price
            await $(`#total-price-${$(this).data('id')}`).text(`Rp ${new Intl.NumberFormat("id-ID").format(cart.TotalPrice)}`);
            await $('#total').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
            await $('#subtotal').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
          },
          error: (res) => {
            Swal.fire({
              toast: true,
              position: 'top-end',
              showConfirmButton: false,
              timer: 2000,
              timerProgressBar: true,
              didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
              },
              icon: 'error',
              title: JSON.parse(res.responseText).message
            });
          }
        }).always(function(res){
          console.log(res);
        })
      } else {
				$(this).closest('.input-group').find('.form-control').val(parseInt(1));
			}
		});
		$('.js-btn-plus').on('click', async function(e){
			e.preventDefault();
			$(this).closest('.input-group').find('.form-control').val(parseInt($(this).closest('.input-group').find('.form-control').val()) + 1);
		
      $.post({
          url: `customer-api/updateInCart/${Number($(this).data('id'))}`,
          headers: {
            ClientID: "61f0d060f1f163.13349246",
            AccessToken : AccessToken
          },
          data: {
            quantity : parseInt($(this).closest('.input-group').find('.form-control').val()),
          },
          success: async (res) =>{
            let response = res.split('[2022-');
            let responseJSON = JSON.parse(response[0]);
            let cart = responseJSON.data;

            await $(`#total-price-${$(this).data('id')}`).text(`Rp ${new Intl.NumberFormat("id-ID").format(cart.TotalPrice)}`);
            
            total += cart.Product.Price
            await $('#total').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)
            await $('#subtotal').text(`Rp ${new Intl.NumberFormat("id-ID").format(total)}`)

          },
          error: (res) => {
            Swal.fire({
              toast: true,
              position: 'top-end',
              showConfirmButton: false,
              timer: 2000,
              timerProgressBar: true,
              didOpen: (toast) => {
                toast.addEventListener('mouseenter', Swal.stopTimer)
                toast.addEventListener('mouseleave', Swal.resumeTimer)
              },
              icon: 'error',
              title: JSON.parse(res.responseText).message
            });
          }
        }).always(function(res){
          console.log(res);
        })

    });

    $('#checkout').click(async function(e){
      e.preventDefault();
      spinner.show();
      await $.get({
        url: 'customer-api/checkout/',
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        success: async (res) =>{
          window.location.href = 'home/thankyou';
        },
        error: (res) => {
          Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 2000,
            timerProgressBar: true,
            didOpen: (toast) => {
              toast.addEventListener('mouseenter', Swal.stopTimer)
              toast.addEventListener('mouseleave', Swal.resumeTimer)
            },
            icon: 'error',
            title: JSON.parse(res.responseText).message
          });
        }
      }).always(function(res){
        console.log(res)
      })
    })
    
  })
</script>
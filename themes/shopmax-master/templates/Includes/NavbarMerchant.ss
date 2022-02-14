<div class="site-navbar bg-white py-3">

  <div class="container">
    <div class="d-flex align-items-center justify-content-between">
      <div class="logo">
        <div class="site-logo">
          <a href="home" class="js-logo-clone">E-Comm</a>
        </div>
      </div>
      <div class="radio" id="isopen" style="display: none">
        <input label="Open" type="radio" name="isopen" value="open" checked>
        <input label="Closed" type="radio" name="isopen" value="closed">
      </div>
      <div class="icons">
        
        <span id="isLogin" style="display: none">
          
          Hi, <span id="nameMerchant">Anu</span>
          <a class="icons-btn d-inline-block ml-2" href='#' role="button" id="user" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
            <%-- <span class="icon-user"></span> --%>
            <span class="">
              <img id="img-profile" class="rounded-circle" alt="photo" width="30" height="30">
            </span>
          </a>

          <div class="dropdown-menu" aria-labelledby="user">
            <a href="merchant/product/" class="dropdown-item">Product</a>
            <a href="merchant/order/" class="dropdown-item">Order</a>
            <a class="dropdown-item" href="merchant">Profile</a>
            <div class="dropdown-divider"></div>
            <a class="dropdown-item text-primary" href="#" id="logout">
              <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-box-arrow-left" viewBox="0 0 16 16">
                <path fill-rule="evenodd" d="M6 12.5a.5.5 0 0 0 .5.5h8a.5.5 0 0 0 .5-.5v-9a.5.5 0 0 0-.5-.5h-8a.5.5 0 0 0-.5.5v2a.5.5 0 0 1-1 0v-2A1.5 1.5 0 0 1 6.5 2h8A1.5 1.5 0 0 1 16 3.5v9a1.5 1.5 0 0 1-1.5 1.5h-8A1.5 1.5 0 0 1 5 12.5v-2a.5.5 0 0 1 1 0v2z"/>
                <path fill-rule="evenodd" d="M.146 8.354a.5.5 0 0 1 0-.708l3-3a.5.5 0 1 1 .708.708L1.707 7.5H10.5a.5.5 0 0 1 0 1H1.707l2.147 2.146a.5.5 0 0 1-.708.708l-3-3z"/>
              </svg>
              <span class="ml-2">Sign Out</span>
            </a>
          </div>
        </span>
                  
        <a href="#" class="site-menu-toggle js-menu-toggle ml-3 d-inline-block d-lg-none"><span class="icon-menu"></span></a>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();
    const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
    const Merchant = JSON.parse(sessionStorage.getItem("Merchant"));
    if(AccessToken){
      await $("#img-profile").attr("src", Merchant.Photo);
      await $('#nameMerchant').text(Merchant.Name)
      $('#isLogin').show();
      $('#isopen').show();
    }


    $("#logout").click(function(){
      spinner.show();
      sessionStorage.clear()
      $("#isLogin").hide();
      window.location.href = 'home';
    })

    spinner.hide();

    $(`input[name=isopen]`).change(function(e){
      e.preventDefault();
      spinner.show();
      let val = $(this).val() == 'open' ? 'true' : 'false' ;
      $.post({
        url: `merchant-api/isOpen/${val}`,
        headers: {
          ClientID: "61f0d060f1f163.13349246",
          AccessToken : AccessToken
        },
        success: async (res) => {
          let response = JSON.parse(res);
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
            icon: 'success',
            title: response.message
          })
        },
        error: (res) => {
          let responseJSON = JSON.parse(res.responseText);
          Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            icon: 'error',
            title: responseJSON.message
          });
        }
      }).always(function(){
        spinner.hide();
      })
    });
  })
</script>
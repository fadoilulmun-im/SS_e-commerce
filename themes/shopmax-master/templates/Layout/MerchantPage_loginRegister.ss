<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Login Merchant</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row">

      <div class="col-6" style="display: none" id="register">
        <form id="formRegister" enctype="multipart/form-data">
          <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" required class="form-control" id="name" name="name">
          </div>
          <div class="form-group">
            <label for="emailReg">Email address</label>
            <input type="email" required class="form-control" id="emailReg" aria-describedby="emailHelp" name="email">
            <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
          </div>
          <div class="form-group">
            <label for="passwordReg">Password</label>

            <div class="input-group show_hide_password">
              <input type="password" required class="form-control" id="passwordReg" name="password">
              <div class="input-group-append">
                <a href="#" class="btn btn-outline-secondary"><i class="bi bi-eye-slash-fill" aria-hidden="true"></i></a>
              </div>
            </div>
          </div>
          <div class="form-group">
            <label for="photo">Photo Profile</label>
            <input type="file" required class="form-control" id="photo" name="photo">
          </div>
          <div class="form-group">
            <label for="category">Category</label>
            <select class="form-control" id="category" required>
              <option disabled selected value=""> Select category </option>
            </select>
          </div>
          <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
        <div class="pt-2 px-2">
          <a href="#" id="showLogin">Already have an account? Login</a>
        </div>
      </div>

      <div class="col-6" id="login">
        <form id="formLogin">
          <div class="form-group">
            <label for="emailLogin">Email address</label>
            <input type="email" required class="form-control" id="emailLogin" aria-describedby="emailHelp" name="email">
            <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
          </div>
          <div class="form-group">
            <label for="passwordLogin">Password</label>
            <div class="input-group show_hide_password">
              <input type="password" required class="form-control" id="passwordLogin" name="password">
              <div class="input-group-append">
                <a href="#" class="btn btn-outline-secondary"><i class="bi bi-eye-slash-fill" aria-hidden="true"></i></a>
              </div>
            </div>
          </div>
          <button type="submit" class="btn btn-primary btn-block">Login</button>
        </form>
        <div class="pt-2 px-2">
          <a href="#" id="showRegister">New around here? Register</a>
        </div>
        <div class="pt-2 px-2">
        <a href="#" >Forgot password?</a>
      </div>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){

    var spinner = $('#loader');
    spinner.show();

    const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
    if(AccessToken){
      window.location.href = 'merchant/order';
    }

    let categories = [];
    $.get({
      url: 'merchant-api/getCategory',
      headers :{
        ClientID: "61f0d060f1f163.13349246"
      },
      success: async (res)=>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        categories = await responseJSON.data;

        categories.forEach((item, index)=>{
          $('#category').append(`
          <option value="${item.ID}"> ${item.Title} </option>
          `)
        })
      },
      error: (res) => {
        alert(JSON.parse(res.responseText).message);
      }
    }).always(function(res){
      spinner.hide();
    })

    $('#formRegister').submit(function(e){
      e.preventDefault();
      spinner.show();

      const name = $("#name").val();
      const email = $("#emailReg").val();
      const password = $("#passwordReg").val();
      const photo = $("#photo")[0].files;
      const category = $("#category").val();

      var formData = new FormData();
      formData.append("name", name);
      formData.append("email", email);
      formData.append("password", password);
      formData.append("photo", photo[0]);
      formData.append("categoryID", category);

      $.post({
        url: 'merchant-api/register',
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        headers :{
          ClientID: "61f0d060f1f163.13349246"
        },
        data: formData,
        success: async(res)=>{
          let responseJSON = JSON.parse(res);

          Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            timer: 3000,
            timerProgressBar: true,
            didOpen: (toast) => {
              toast.addEventListener('mouseenter', Swal.stopTimer)
              toast.addEventListener('mouseleave', Swal.resumeTimer)
            },
            icon: 'success',
            title: responseJSON.message
          })

        },
        error: (res) => {
          let responseJSON = JSON.parse(res.responseText);
          Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            icon: 'error',
            title: `${responseJSON.message}, ${JSON.stringify(responseJSON.data[0])}`
          })

          console.log(res);
        }
      }).always(function(res){
        console.log(res);
        spinner.hide();
      })
    })

    $('#formLogin').submit(async function(e){
      e.preventDefault();
      spinner.show();
      $.post({
        url: 'merchant-api/login',
        headers :{
          ClientID: "61f0d060f1f163.13349246"
        },
        data:{
          email: $("#emailLogin").val(),
          password: $("#passwordLogin").val()
        },
        success: async(res)=>{
          let response = JSON.parse(res);

          $('#isLogin').show();
          sessionStorage.setItem("Merchant", JSON.stringify(response.data));
          sessionStorage.setItem("AccessTokenMerchant", response.AccessToken);

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

          window.location.href = 'merchant/order';
        },
        error: async (res) => {
          let responseJSON = JSON.parse(res.responseText);
          await Swal.fire({
            toast: true,
            position: 'top-end',
            showConfirmButton: false,
            icon: 'error',
            title: responseJSON.message
          });
        }
      }).always(function(res){
        console.log(res);
        spinner.hide();
      })
    })

    $('#showRegister').click(async function(e){
      e.preventDefault();
      $('#Title').text('Register Merchant')
      await $('#login').hide();
      $('#register').show('slow');
    })

    $('#showLogin').click(async function(e){
      e.preventDefault();
      $('#Title').text('Login Merchant')
      await $('#register').hide();
      $('#login').show('slow');
    })
  })
</script>
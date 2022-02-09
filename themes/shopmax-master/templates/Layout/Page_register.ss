<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">Register</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row">
      <div class="col-6">
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

            <div class="input-group" id="show_hide_password">
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
          <button type="submit" class="btn btn-primary btn-block">Submit</button>
        </form>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){
    $("#show_hide_password a").on('click', function(event) {
        event.preventDefault();
        if($('#show_hide_password input').attr("type") == "text"){
            $('#show_hide_password input').attr('type', 'password');
            $('#show_hide_password i').addClass( "bi bi-eye-slash" );
            $('#show_hide_password i').removeClass( "bi bi-eye" );
        }else if($('#show_hide_password input').attr("type") == "password"){
            $('#show_hide_password input').attr('type', 'text');
            $('#show_hide_password i').removeClass( "bi bi-eye-slash" );
            $('#show_hide_password i').addClass( "bi bi-eye" );
        }
    });

    $("#formRegister").submit((e)=>{
      e.preventDefault();
      var spinner = $('#loader');
      spinner.show();

      const name = $("#name").val();
      const email = $("#emailReg").val();
      const password = $("#passwordReg").val();
      const photo = $("#photo")[0].files;

      console.log(photo[0]);
      var formData = new FormData();
      formData.append("name", name);
      formData.append("email", email);
      formData.append("password", password);
      formData.append("photo", photo[0]);
      
      for (var value of formData.values()) {
        console.log(value);
      }

      var settings = {
        "url": "customer-api/register",
        "method": "POST",
        "enctype": 'multipart/form-data',
        "processData": false,
        "contentType": false,
        "headers": {
          "ClientID": "61f0d060f1f163.13349246"
        },
        "data": formData,
        success: (res)=>{
          let responseJSON = JSON.parse(res);
          alert(responseJSON.message);
          window.location.href = 'shop';
        },
        error: (res) => {
          alert(JSON.parse(res.responseText).message);
        }
      };

      $.ajax(settings).always(function (res) {
        console.log(res);
        spinner.hide();
      });
      
    })
  })

  
</script>
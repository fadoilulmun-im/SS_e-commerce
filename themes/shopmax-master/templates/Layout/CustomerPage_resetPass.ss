<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0">Reset Password</h3>
    </div>
  </div>
</div>

<div class="site-section pt-5">
  <div class="container">
    <div class="row">
      <div class="col-6" id="content">
        <% if $isValid %>
          <form id="formReset">
            <div class="form-group">
              <label for="newPassword">New Password</label>

              <div class="input-group" id="show_hide_password">
                <input type="password" name='password' id="newPassword" class="form-control" name="password" required autocomplete="current-password">
                <div class="input-group-append">
                  <a href="#" class="btn btn-outline-secondary"><i class="bi bi-eye-slash-fill" aria-hidden="true"></i></a>
                </div>
              </div>
            </div>
            
            <button type="submit" class="btn btn-primary btn-block">Submit</button>
          </form>
        <% else %>
          $Content
        <% end_if %>
        
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(e){

    const spinner = $('#loader');

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

    $('#formReset').submit(async function(e){
      e.preventDefault();
      spinner.show();

      let id = await (window.location.pathname).split('/');
      id = await id[id.length -1];

      const password = $('#newPassword').val();
      $.post({
        url: `customer-api/resetPassword/${id}`,
        headers:{
          ClientID: "61f0d060f1f163.13349246",
        },
        data:{
          password: password
        },
        success: async(res) =>{
          const response = JSON.parse(res);
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
          window.location.href = 'home';
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
        spinner.hide();
        console.log(res);
      })
    })
  })
</script>
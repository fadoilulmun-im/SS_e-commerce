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
              <input type="password" class="form-control" id="newPassword" name="password">
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
        success: (res) =>{
          const response = JSON.parse(res);
          alert(response.message);
          window.location.href = 'home';
        },
        error: (res) => {
          alert(JSON.parse(res.responseText).message);
        }
      }).always(function(res){
        spinner.hide();
        console.log(res);
      })
    })
  })
</script>
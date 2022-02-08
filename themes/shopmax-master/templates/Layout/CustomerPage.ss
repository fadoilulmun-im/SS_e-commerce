<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="merchant-title">Profile</h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row" id="content">
      
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

    const user = await JSON.parse(sessionStorage.getItem("User"));
    await $('#content').html(`
      <div class="col-md-6">
        <form id="formProf" enctype="multipart/form-data">
          <div class="form-group">
            <label for="name">Full Name</label>
            <input type="text" class="form-control" id="nameProf" name="name" value="${user.name}">
          </div>
          <div class="form-group">
            <label for="emailProf">Email address</label>
            <input type="email" class="form-control" id="emailProf" aria-describedby="emailHelp" name="email" value="${user.email}">
            <small id="emailHelp" class="form-text text-muted">We'll never share your email with anyone else.</small>
          </div>
          <div class="form-group">
            <label for="passwordProf">Password</label>
            <input type="password" class="form-control" aria-describedby="passHelp" id="passwordProf" name="password">
            <small id="passHelp" class="form-text text-muted">Only fill in the password if you really want to change it</small>
          </div>
          <button type="submit" class="btn btn-primary btn-block">Update</button>
        </form>
      </div>
      <div class="col-md-6">
        <label for="photo">Change Photo Profile</label>
        <input type="file" class="form-control" id="photo" name="photo">
        <br>
        <img src="${user.photo}" id="photo-profile" class="rounded my-auto mx-auto img-thumbnail d-block" alt="...">
        
      </div>
    `)

    spinner.hide();

    $('#formProf').submit(function(e){
      e.preventDefault();
      spinner.show();

      $.post({
        url: 'customer-api/update',
        headers :{
          "ClientID": "61f0d060f1f163.13349246",
          "AccessToken" : AccessToken
        },
        data:{
          name: $('#nameProf').val(),
          email: $('#emailProf').val(),
          password: $('#passProf').val(),
        },
        success: (res)=>{
          const response = JSON.parse(res);
          const data = response.data;
          sessionStorage.setItem("User", JSON.stringify(data));
          $('#nameProf').val(data.name);
          $('#emailProf').val(data.email);
        },
        error: (res) => {
          alert(JSON.parse(res.responseText).message);
        }
      }).always(function(res){
        spinner.hide();
      })
    })

    $('#photo').change(async function(e){
      e.preventDefault();
      spinner.show();
      const photo = $("#photo")[0].files;
      const formData = new FormData();
      formData.append("photo", photo[0]);

      await $.post({
        url: `customer-api/changePhotoProfile`,
        enctype: 'multipart/form-data',
        processData: false,
        contentType: false,
        headers :{
          "ClientID": "61f0d060f1f163.13349246",
          "AccessToken" : AccessToken
        },
        data: formData,
        success: (res)=>{
          const response = JSON.parse(res);
          const data = response.data;
          sessionStorage.setItem("User", JSON.stringify(data));
          $('#photo-profile').attr('src', data.photo);
          $('#img-profile').attr('src', data.photo);
        },
        error: (res) => {
          alert(JSON.parse(res.responseText).message);
        }
      }).always(function(res){
        spinner.hide();
      })
    })
    
  })
</script>
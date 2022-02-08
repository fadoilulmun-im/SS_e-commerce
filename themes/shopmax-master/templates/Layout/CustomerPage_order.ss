<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="merchant-title">List Order</h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row">
      <div class="col-12">
        <table class="table table-hover table-sm">
          <thead>
            <tr>
              <th scope="col">No</th>
              <th scope="col">Total</th>
              <th scope="col">Time Order</th>
              <th scope="col">Status</th>
              <th scope="col">Action</th>
            </tr>
          </thead>
          <tbody id="orders">
            
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>

<script>
  $(document).ready(function(){
    var spinner = $('#loader');
    spinner.show();

    const AccessToken = sessionStorage.getItem("AccessToken");
    if(!AccessToken){
      alert("Please login first to continue");
      window.history.back();
    }

    let orders = [];
    $.get({
      url: 'customer-api/listOrder',
      headers: {
        ClientID: "61f0d060f1f163.13349246",
        AccessToken: AccessToken
      },
      success: async (res) =>{
        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        orders = await responseJSON.data;

        orders.forEach((item, index) =>{
          $('#orders').append(`
            <a href="/">
              <tr>
                <th scope="row">${index + 1}</th>
                <td>${"Rp "+ new Intl.NumberFormat("id-ID").format(item.TotalPrice) }</td>
                <td>${item.Time}</td>
                <td>${item.IsAccept === null ? 'Waiting' : item.IsAccept+'ed'}</td>
                <td>
                  <a href="customer/order/${item.ID}" class="btn btn-info text-white" style="height: unset;">Show</a>
                </td>
              </tr>
            </a>
          `)
        })
      },
      error: (res) => {
        alert(JSON.parse(res.responseText).message);
        window.history.back();
      }
    }).always(function(res){
      spinner.hide();
      console.log(res);
    })
  })
</script>
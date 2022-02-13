<div class="bg-light py-3 pl-4">
  <div class="container">
    <div class="row">
      <h3 class="mb-0" id="Title">Orders</h3>
    </div>
  </div>
</div>

<div class="site-section">
  <div class="container">
    <div class="row mb-5">
      <div class="col-12">
        <table class="table table-stripped text-dark" id="data-table" style="width:100%">
          <thead>
            <tr>
              <th >ID</th>
              <th >Total</th>
              <th >Time Order</th>
              <th>Status</th>
              <th >Action</th>
            </tr>
          </thead>
          <tbody id="lists-product">
            
          </tbody>
        </table>
      </div>
      
    </div>

  </div>
</div>

<script>
  $(document).ready(async function(){
    var spinner = $('#loader');
    spinner.show();

    const AccessToken = sessionStorage.getItem("AccessTokenMerchant");
    
    await $.get({
      url: 'merchant-api/listOrders',
      headers: {
        ClientID: "61f0d060f1f163.13349246",
        AccessToken : AccessToken
      },
      success: async(res)=>{

        let response = res.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        let data = await responseJSON.data;

        data.forEach((item, index)=>{
          $('#lists-product').append(`
            <tr>
              <td>#${item.ID}</td>
              <td>${"Rp "+ new Intl.NumberFormat("id-ID").format(item.TotalPrice) }</td>
              <td>${item.Time}</td>
              <td>${item.IsAccept === null ? 'Waiting' : item.IsAccept+'ed'}</td>
              <td>
                <a class="btn-sm btn-info text-white">Show</a>
                <a class="btn-sm btn-warning text-white">Edit</a>
                <a class="btn-sm btn-danger text-white">Delete</a>
              </td>
            </tr>
          `)
        })
        $('.btn-sm').css('cursor', 'pointer');
        $('#data-table').DataTable();

      },
      error: (res) => {
        let response = res.responseText.split('[2022-');
        let responseJSON = JSON.parse(response[0]);
        alert(responseJSON.message);
        window.history.back();
      }
    }).always(function(res){
      spinner.hide();
    })
  })
</script>
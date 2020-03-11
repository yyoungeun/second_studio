using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using DevDapper.Models;
using DevDapper.Repositories;

namespace DevDapper
{
    public partial class FrmMaximWrite : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void btnWrite_Click(object sender, EventArgs e)
        {
            Maxim maxim = new Maxim();
            maxim.Name = txtName.Text;
            maxim.Content = txtContent.Text;

            MaximServiceRepository repo = new MaximServiceRepository();
            maxim.Id = repo.AddMaxim(maxim).Id;

            lblDisplay.Text = maxim.Id.ToString() + "번 데이터가 입력되었습니다.";
        }
    }
}
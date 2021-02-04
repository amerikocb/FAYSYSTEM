using LibreriaDatos.DTO;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class MovimientoMateriales : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgMovimientoMateriales.DataSource = db.MvtoMateriales.ObtenerMovimientoMateriales();
                dgMovimientoMateriales.DataBind();
            }
        }

    }
}
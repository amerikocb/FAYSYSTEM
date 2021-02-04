using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class MarcaMateriales : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgMateriales.DataSource = db.Material.ObtenerMateriales();
                dgMateriales.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgMateriales.DataBind();
            }

        }
        protected void dgMMateriales_BeforePerformDataSelect(object sender, EventArgs e)
        {
            try
            {
                Session["IdMaterial"] = (sender as ASPxGridView).GetMasterRowKeyValue();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        protected void dgMMateriales_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView dg = (ASPxGridView)sender;
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    foreach (var item in e.InsertValues)
                    {
                        db.MarcaMaterial.InsertarValoresMarcaMaterial(item.NewValues, int.Parse(dg.GetMasterRowKeyValue().ToString()));
                    }

                    foreach (var item in e.UpdateValues)
                    {
                        db.MarcaMaterial.ActualizarMarcaMaterial(item.Keys, item.NewValues);
                    }
                    foreach (var item in e.DeleteValues)
                    {
                        db.MarcaMaterial.EliminarMarcaMaterial(item.Keys);
                    }
                }
                dg.JSProperties["cpOperacionesGrid"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                dg.JSProperties["cpOperacionesGrid"] = "Error: " + ex.Message;
            }
            e.Handled = true;
        }
    }
}
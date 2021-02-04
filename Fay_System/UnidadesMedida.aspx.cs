using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class UnidadesMedida : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (rblOpUnidades.Value.ToString() == "Servicios")
            {
                cargarData(1);
            }

            if (dgMateriales.IsCallback)
                cargarData(2);

            else if (dgServicios.IsCallback)
                cargarData(1);

        }

        protected void cargarData(int opcion)
        {
            using (var db = new UnidadDeTrabajo())
            {
                if (opcion ==1)
                {
                    //dgMateriales.Visible = false;
                    dgServicios.DataSource = db.Servicio.ObtenerServicios();
                    dgServicios.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                    dgServicios.DataBind();
                }
                else
                {
                    //dgServicios.Visible = false;
                    dgMateriales.DataSource = db.Material.ObtenerMateriales();
                    dgMateriales.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                    dgMateriales.DataBind();
                }
            }
        }

        protected void dgUMServicios_BeforePerformDataSelect(object sender, EventArgs e)
        {
            try
            {
                Session["IdService"] = (sender as ASPxGridView).GetMasterRowKeyValue();
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message);
            }
        }

        protected void dgUMServicios_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView dg = (ASPxGridView)sender;
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    foreach (var item in e.InsertValues)
                    {
                        db.UnidadMedida.InsertarValoresUnidadMedida(item.NewValues, int.Parse(dg.GetMasterRowKeyValue().ToString()), null);
                    }

                    foreach (var item in e.UpdateValues)
                    {
                        db.UnidadMedida.ActualizarUnidadMedida(item.Keys, item.NewValues);
                    }
                    foreach (var item in e.DeleteValues)
                    {
                        db.UnidadMedida.EliminarUnidadMedida(item.Keys);
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

        protected void dgUMMateriales_BeforePerformDataSelect(object sender, EventArgs e)
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

        protected void dgUMMateriales_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            ASPxGridView dg = (ASPxGridView)sender;
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    foreach (var item in e.InsertValues)
                    {
                        db.UnidadMedida.InsertarValoresUnidadMedida(item.NewValues, null, int.Parse(dg.GetMasterRowKeyValue().ToString()));
                    }

                    foreach (var item in e.UpdateValues)
                    {
                        db.UnidadMedida.ActualizarUnidadMedida(item.Keys, item.NewValues);
                    }
                    foreach (var item in e.DeleteValues)
                    {
                        db.UnidadMedida.EliminarUnidadMedida(item.Keys);
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

        protected void cpObtainDataGv_Callback(object sender, CallbackEventArgsBase e)
        {
            cargarData(int.Parse(e.Parameter));
        }
    }
}
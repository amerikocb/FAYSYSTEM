using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class OrdenesCompra : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarRecepciones();
        }
        protected void cargarRecepciones()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgOrdenesCompra.DataSource = db.OrdenCompra.ObtenerListaOrdenesCompra();
                dgOrdenesCompra.DataBind();
            }
        }
        protected void addOrdenCompra_Click(object sender, EventArgs e)
        {
            pcEditorOrdenesCompra.ShowOnPageLoad = true;
            using (var db = new UnidadDeTrabajo())
            {
                dgOrdenCompraDetalle.DataSource = db.OrdenCompraDetalle.ObtenerDetalleOrdenCompra(0);
                dgOrdenCompraDetalle.DataBind();
            }
            //Session["Accion"] = "Insertar";
            //Session["IdEstadoOrdenCompra"] = 26;
        }

        protected void dgOrdenesCompra_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    dgOrdenCompraDetalle.DataSource = wu.OrdenCompraDetalle.ObtenerDetalleOrdenCompra(int.Parse(dgOrdenesCompra.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    dgOrdenCompraDetalle.DataBind();

                    var ordenCompra = wu.OrdenCompra.ObtenerOrdenCompraPorId(int.Parse(dgOrdenesCompra.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    txtFecha.Text = ordenCompra.Fecha.ToString();
                    txtProveedor.Text = ordenCompra.RazonSocial;
                    txtEstadoOCD.Text = ordenCompra.Estado;
                    txtDocumentoRef.Text = ordenCompra.DocumentoReferencia;
                    pcEditorOrdenesCompra.ShowOnPageLoad = true;
                    break;
                case "Anular":
                    OrdenCompra OrdenC_anular = wu.OrdenCompra.ObtenerPorId(int.Parse(dgOrdenesCompra.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (OrdenC_anular.IdEstado != 10)
                    {
                        MostrarMensajes("Solo se puede anular una orden de compra que aún no ha sido recepcionada");
                    }
                    else
                    {
                        OrdenC_anular.IdEstado = 11;
                        wu.OrdenCompra.Actualizar(OrdenC_anular);
                        wu.Grabar();
                        cargarRecepciones();
                    }

                    break;
                case "ViewReport":
                    Session["ItemClickeado"] = "OrdenCompra";
                    string url = "Reporte.aspx?idoc=" + int.Parse(dgOrdenesCompra.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.Write("<script>window.open('" + url + "','_blank');</script>");
                    break;
            }
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgOrdenCompraDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
                if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                    e.Visible = false;
        }
    }
}
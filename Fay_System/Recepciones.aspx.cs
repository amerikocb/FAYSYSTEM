using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class Recepciones : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarRecepciones();
        }
        protected void cargarRecepciones()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgRecepciones.DataSource = db.Recepcion.ObtenerListaRecepciones();
                dgRecepciones.DataBind();
            }
        }
        protected void addRecepcion_Click(object sender, EventArgs e)
        {
            pcEditorRecepciones.ShowOnPageLoad = true;
            deFechaRecepcion.Value = DateTime.Today;
            cmbProveedor.ClientEnabled = false;
            dgRecepcionDetalle.Visible = false;
            dgRecepcionDetalleNew.Visible = false;
            using (var db = new UnidadDeTrabajo())
            {

                cmbIdOrdenCompra.DataSource = db.OrdenCompra.ObtenerListaOrdenesCompraPendientesDeRecepcion();
                cmbIdOrdenCompra.DataBind();

                cmbProveedor.DataSource = db.Empresa.ObtenerListaProveedores();
                cmbProveedor.DataBind();

                dgRecepcionDetalleNew.DataSource = db.OrdenCompraDetalle.ObtenerDetalleOrdenCompraPorIdOC(-1000);
                dgRecepcionDetalleNew.DataBind();
            }
            cmbIdOrdenCompra.Value = null;
            cmbProveedor.Value = null;
            txtNumeroDocumento.Value = null;
            txtNumeroGuia.Value = "0";
            txtSerieDocumento.Value = null;
            txtSerieGuia.Value = "S";
            txtEstadoRecep.Value = "Activo";
            cmbTipoDocumento.SelectedIndex = -1;
        }

        protected void dgRecepciones_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    dgRecepcionDetalle.Visible = true;
                    cmbIdOrdenCompra.DataSource = wu.OrdenCompra.ObtenerListaOrdenesCompra();
                    cmbIdOrdenCompra.ValueField = "Id";
                    cmbIdOrdenCompra.TextField = "RazonSocial";
                    cmbIdOrdenCompra.DataBind();

                    cmbIdOrdenCompra.ReadOnly = true;

                    //cmbProveedor.DataSource = wu.Empresa.ObtenerListaProveedores();
                    //cmbProveedor.DataBind();

                    cmbTipoDocumento.DataSource = wu.TipoDocumento.Obtener();
                    cmbTipoDocumento.DataBind();

                    //var ordenCompra = wu.OrdenCompra.ObtenerListaOrdenesCompra().ToList();
                    //ordenCompra.
                    Recepcion Recepcion = wu.Recepcion.ObtenerPorId(int.Parse(dgRecepciones.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    cmbIdOrdenCompra.Value = Recepcion.IdOrdenCompra;
                    cmbProveedor.Value = Recepcion.IdEmpresa;
                    deFechaRecepcion.Value = Recepcion.Fecha;
                    txtNumeroDocumento.Value = Recepcion.NumeroComprobante;
                    txtSerieDocumento.Value = Recepcion.SerieComprobante;
                    txtNumeroGuia.Value = Recepcion.NumeroGuiaRemision;
                    txtSerieGuia.Value = Recepcion.SerieGuiaRemision;
                    cmbProveedor.Value = Recepcion.IdEmpresa;
                    dgRecepcionDetalle.DataSource = wu.RecepcionDetalle.ObtenerDetalleRecepcion(Recepcion.Id);
                    dgRecepcionDetalle.DataBind();
                    cmbTipoDocumento.Value = Recepcion.IdTipoDocumento;
                    dgRecepcionDetalleNew.Visible = false;
                    pcEditorRecepciones.ShowOnPageLoad = true;
                    break;
                case "Anular":
                    Recepcion OrdenC_anular = wu.Recepcion.ObtenerPorId(int.Parse(dgRecepciones.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    OrdenC_anular.IdEstado = 11;
                    wu.Recepcion.Actualizar(OrdenC_anular);
                    wu.Grabar();
                    cargarRecepciones();
                    break;
                case "showReport":
                    Session["ItemClickeado"] = "RecepcionCompra";
                    string url = "Reporte.aspx?Recepcion=" + int.Parse(dgRecepciones.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.Write("<script>window.open('" + url + "','_blank');</script>");
                    break;
            }
        }

        protected void dgRecepcionDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }

        protected void cmbIdOrdenCompra_ValueChanged(object sender, EventArgs e)
        {
            dgRecepcionDetalle.Visible = false;
            dgRecepcionDetalleNew.Visible = true;
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    cmbIdOrdenCompra.DataSource = db.OrdenCompra.ObtenerListaOrdenesCompraPendientesDeRecepcion();
                    cmbIdOrdenCompra.DataBind();

                    dgRecepcionDetalleNew.DataSource = db.OrdenCompraDetalle.ObtenerDetalleOrdenCompraPorIdOC(int.Parse(cmbIdOrdenCompra.Value.ToString()));
                    dgRecepcionDetalleNew.DataBind();

                    cmbTipoDocumento.DataSource = db.TipoDocumento.Obtener();
                    cmbTipoDocumento.DataBind();
                    cmbTipoDocumento.SelectedIndex = 0;

                    cmbProveedor.Value = db.OrdenCompra.ObtenerPorId(int.Parse(cmbIdOrdenCompra.Value.ToString())).IdEmpresa;
                }
            }
            catch(Exception ex) {
                MostrarMensajes("Ha ocurrido un error: " + ex.Message);
            }

        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgRecepcionDetalleNew_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "Seleccion" || e.Column.FieldName == "CantidadRecibida") { e.Editor.ReadOnly = false; }
        }

        protected void dgRecepcionDetalleNew_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    Recepcion recepcion = new Recepcion
                    {
                        Fecha = DateTime.Now,
                        FechaCreacion = DateTime.Now,
                        IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                        IdEmpresa = int.Parse(cmbProveedor.Value.ToString()),
                        IdOrdenCompra = int.Parse(cmbIdOrdenCompra.Value.ToString()),
                        IdTipoDocumento = int.Parse(cmbTipoDocumento.Value.ToString()),
                        SerieComprobante = txtSerieDocumento.Text,
                        NumeroComprobante = int.Parse(txtNumeroDocumento.Value.ToString()),
                        SerieGuiaRemision = txtSerieGuia.Text,
                        NumeroGuiaRemision = txtNumeroGuia.Value != null ? int.Parse(txtNumeroGuia.Text) : 0,
                        IdEstado = 22,
                        IdAlmacen = 1,
                    };
                    db.Recepcion.Insertar(recepcion);
                    db.Grabar();
                    foreach (var item in e.UpdateValues)
                    {
                        db.RecepcionDetalle.InsertarValoresRecepcionDetalle(item.NewValues, recepcion.Id);
                    }
                    if(db.RecepcionDetalle.SumaCantidades_x_OrdenCompra(int.Parse(cmbIdOrdenCompra.Value.ToString())) == db.RecepcionDetalle.SumaCantidadesRecibidas_x_OrdenCompra(int.Parse(cmbIdOrdenCompra.Value.ToString())))
                    {
                        db.OrdenCompra.RecepcionarOrdenCompra(int.Parse(cmbIdOrdenCompra.Value.ToString()), 12);
                    }
                    else db.OrdenCompra.RecepcionarOrdenCompra(int.Parse(cmbIdOrdenCompra.Value.ToString()), 21);
                }
                pcEditorRecepciones.ShowOnPageLoad = false;
                dgRecepcionDetalleNew.JSProperties["cpAdminOperacion"] = "Operación realizada con éxito";
            }
            catch(Exception ex)
            {
                dgRecepcionDetalleNew.JSProperties["cpAdminOperacion"] = "Ha ocurrido un error inesperado: " +ex.Message;
            }
            e.Handled = true;
        }

        protected void cpOpenReport_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            Session["ItemClickeado"] = "RecepcionCompra";
            cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?Recepcion=" + int.Parse(e.Parameter.ToString());
        }
    }
}
using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Linq;

namespace Fay_System
{
    public partial class Cotizaciones : System.Web.UI.Page
    {
        string NumeroCotizacion = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            NumeroCotizacion = Request.QueryString["Id"];
            hfIdCotizacion["IdCotizacion"] = NumeroCotizacion;
            txtPrecioDolar.Text = wu.ObenerPrecioDolar().ToString();
            deFechaEntrega.Value = DateTime.Today;
            cargarCotizaciones();
            if (pcListadoEmpresas.IsCallback || dgEmpresas.IsCallback)
            {
                dgEmpresas.DataSource = wu.Empresa.ObtenerListaEmpresas();
                dgEmpresas.DataBind();
            }
            if (pcListadoClientes.IsCallback || dgClientes.IsCallback)
            {
                dgClientes.DataSource = wu.Cliente.ObtenerListaClientes();
                dgClientes.DataBind();
            }
            if (NumeroCotizacion == "Nuevo")
            {
                btnSaveCosto.ClientEnabled = false;
                dgCotizacionDetalle.DataSource = wu.CotizacionDetalle.ObtenerDetalleCotizacion(0);
                dgCotizacionDetalle.DataBind();
                pcEditorCotizaciones.ShowOnPageLoad = true;
            }
            if (NumeroCotizacion != null && NumeroCotizacion != "Nuevo")
            {
                btnSaveCosto.ClientEnabled = true;
                if (int.Parse(NumeroCotizacion) > 0)
                {
                    int?[] estateBad = { 36, 47 };
                    Cotizacion cot = new Cotizacion();
                    using (var bd = new UnidadDeTrabajo())
                    {
                        cot = bd.Cotizacion.ObtenerPorId(int.Parse(NumeroCotizacion));
                        deFechaEntrega.Value = cot.FechaEntrega;
                        if (cot.IdClienteNatural > 0)
                        {
                            Cliente cliente = bd.Cliente.ObtenerPorId(cot.IdClienteNatural);
                            txtApelNomRazSoc.Text = cliente.Persona.ApellidoPaterno + " " + cliente.Persona.ApellidoMaterno + ", " + cliente.Persona.Nombres;
                            txtRucDni.Text = cliente.Persona.DNI;
                            rbOpciones.Value = 1;
                            lblApelNomRazSoc.Text = "Apell. Nombres:";
                            lblRucDni.Text = "DNI:";
                        }
                        else
                        {
                            Empresa empresa = bd.Empresa.ObtenerPorId(cot.IdClienteJuridico);
                            txtApelNomRazSoc.Text = empresa.Persona.RazonSocial;
                            txtRucDni.Text = empresa.Persona.Ruc;
                            rbOpciones.Value = 2;
                            lblApelNomRazSoc.Text = "Razón Social:";
                            lblRucDni.Text = "RUC:";
                        }
                        if (estateBad.Contains(cot.IdEstado))
                        {
                            dgCotizacionDetalle.SettingsEditing.Mode = GridViewEditingMode.Inline;
                            dgCotizacionDetalle.Columns[0].Visible = false;
                            deFechaEntrega.ClientEnabled = false;
                        }
                        dgCotizacionDetalle.DataSource = bd.CotizacionDetalle.ObtenerDetalleCotizacion(int.Parse(NumeroCotizacion));
                        dgCotizacionDetalle.DataBind();
                    }

                    txtApelNomRazSoc.ClientEnabled = false;
                    txtRucDni.ClientEnabled = false;
                    rbOpciones.ClientEnabled = false;
                }
                pcEditorCotizaciones.ShowOnPageLoad = true;
            }

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 18) == true)
                    {
                        btnBuscarPersonas.ClientEnabled = false;
                        addCotizaciones.ClientEnabled = false;
                        dgCotizacionDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                        dgCotizacionDetalle.Columns[0].Visible = false;
                    }
                }
            }
        }
        protected void cargarCotizaciones()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgCotizaciones.DataSource = db.Cotizacion.ObtenerListaCotizaciones();
                dgCotizaciones.DataBind();
            }
        }
        protected void addCotizaciones_Click(object sender, EventArgs e)
        {
            string url = "Cotizaciones.aspx?Id=Nuevo";
            Response.Redirect(url);
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgCotizacionDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            NumeroCotizacion = Request.QueryString["Id"];
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    if (NumeroCotizacion == "Nuevo")
                    {
                        int? idClienteN = null, IdClienteJ = null;
                        if (int.Parse(rbOpciones.Value.ToString()) == 1) { idClienteN = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        if (int.Parse(rbOpciones.Value.ToString()) == 2) { IdClienteJ = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        Cotizacion Cot = new Cotizacion
                        {
                            Fecha = DateTime.Now,
                            FechaCreacion = DateTime.Now,
                            IdClienteNatural = idClienteN,
                            IdClienteJuridico = IdClienteJ,
                            IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                            TipoCotizacion = int.Parse(rbOpciones.Value.ToString()) == 1 ? "PN-COMAT" : "PJ-COMAT",
                            DocumentoReferencia = "",
                            IdEstado = 35,
                            FechaEntrega = DateTime.Parse(deFechaEntrega.Value.ToString())
                        };
                        db.Cotizacion.Insertar(Cot);
                        db.Grabar();
                        foreach (var item in e.InsertValues)
                        {
                            db.CotizacionDetalle.InsertarValoresCotizacionDetalle(item.NewValues, Cot.Id, decimal.Parse(txtPrecioDolar.Text));
                        }
                        NumeroCotizacion = Cot.Id.ToString();
                        string url = "Cotizaciones.aspx?Id=" + NumeroCotizacion;
                        Response.RedirectLocation = url;
                    }
                    else
                    {
                        foreach (var item in e.InsertValues)
                        {
                            db.CotizacionDetalle.InsertarValoresCotizacionDetalle(item.NewValues, int.Parse(NumeroCotizacion.ToString()), decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.UpdateValues)
                        {
                            db.CotizacionDetalle.ActualizarCotizacionDetalle(item.Keys, item.NewValues, decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.DeleteValues)
                        {
                            db.CotizacionDetalle.EliminarCotizacionDetalle(item.Keys);
                        }
                    }
                    dgCotizacionDetalle.DataSource = db.CotizacionDetalle.ObtenerDetalleCotizacion(int.Parse(NumeroCotizacion));
                    dgCotizacionDetalle.DataBind();
                }
                dgCotizacionDetalle.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
                //cargarCotizaciones();
            }
            catch (Exception ex)
            {
                dgCotizacionDetalle.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;

        }

        protected void dgCotizaciones_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            dgCotizaciones.JSProperties["cpOperacionesCot"] = null;
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    string url = "Cotizaciones.aspx?Id=" + int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "Anular":
                    try
                    {
                        Cotizacion Cot_anular = wu.Cotizacion.ObtenerPorId(int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        if (Cot_anular.IdEstado == 36) dgCotizaciones.JSProperties["cpOperacionesCot"] = "Operación denegada, la cotización ya ha sido anulada";
                        else if (Cot_anular.IdEstado == 47) dgCotizaciones.JSProperties["cpOperacionesCot"] = "Operación denegada, la cotización ya ha sido convertida en orden de venta";
                        else
                        {
                            Cot_anular.IdEstado = 36;
                            wu.Cotizacion.Actualizar(Cot_anular);
                            wu.Grabar();
                            cargarCotizaciones();
                            dgCotizaciones.JSProperties["cpOperacionesCot"] = "Operación realizada con éxito";
                        }
                    }
                    catch (Exception ex)
                    {
                        dgCotizaciones.JSProperties["cpOperacionesCot"] = "Ha ocurrido un error inesperado: " + ex.Message;
                    }

                    break;
                case "btnToOrdenVenta":
                    string mensaje = null;
                    try
                    {
                        Cotizacion cot_ov = new Cotizacion();
                        using (var db = new UnidadDeTrabajo())
                        {
                            cot_ov = db.Cotizacion.ObtenerPorId(int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        }
                        bool resultado = false;
                        switch (cot_ov.IdEstado)
                        {
                            case 47: mensaje = "Operación denegada: la cotización ya es una orden de venta"; break;
                            case 36: mensaje = "Operación denegada: la cotización ha sido anulada"; break;
                        }
                        int idusuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                        if (mensaje == null)
                        {
                            resultado = wu.Cotizacion.ConvertirCotizacion_OrdenVenta(int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString()), idusuario);
                            if (resultado)
                            {
                                using (var db = new UnidadDeTrabajo())
                                {
                                    cot_ov = db.Cotizacion.ObtenerPorId(int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString()));
                                    cot_ov.IdEstado = 47;
                                    db.Cotizacion.Actualizar(cot_ov);
                                    db.Grabar();
                                }
                                dgCotizaciones.JSProperties["cpOperacionesCot"] = "Operación realizada con éxito";
                            }
                            cargarCotizaciones();
                        }
                        else dgCotizaciones.JSProperties["cpOperacionesCot"] = mensaje;
                    }
                    catch (Exception ex)
                    {
                        dgCotizaciones.JSProperties["cpOperacionesCot"] = "Ha ocurrido un erro inesperado: " + ex.Message;
                    }
                    break;
                case "VerReporteC":
                    Session["ItemClickeado"] = "Cotizacion";
                    dgCotizaciones.JSProperties["cpRedireccion"] = "Reporte.aspx?Cot=" + int.Parse(dgCotizaciones.GetRowValues(e.VisibleIndex, "Id").ToString());
                    break;
            }
        }
        protected void dgCotizacionDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();

            int?[] estateBad = { 36, 47 };
            if (NumeroCotizacion != null && NumeroCotizacion != "Nuevo")
            {
                NumeroCotizacion = Request.QueryString["Id"];
                if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && estateBad.Contains(wu.Cotizacion.ObtenerEstadoCotizacion(int.Parse(NumeroCotizacion))))
                    e.Visible = false;
            }
        }
        protected void generico_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }

        protected void cpGetPrecioServ_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioServ.JSProperties["cpPrecioS"] = ut.Servicio.ObtenerPrecioServicio(int.Parse(e.Parameter.ToString())).ToString();
            }
        }

        protected void dgCotizaciones_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.ButtonID == "btnToOrdenVenta" || e.ButtonID == "Anular")
            {
                using (var ut = new UnidadDeTrabajo())
                {
                    if (Session["IdUserActive"] != null)
                    {
                        if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 18) == true)
                        {
                            e.Visible = DevExpress.Utils.DefaultBoolean.False;
                        }
                    }
                }
            }
        }

        protected void cpSaveCosto_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            try
            {
                using (var ut = new UnidadDeTrabajo())
                {
                    Cotizacion cot = ut.Cotizacion.ObtenerPorId(int.Parse(e.Parameter.ToString()));
                    cot.CostoTotal = int.Parse(seCostoTotal.Value.ToString());
                    cot.AdelantoPago = int.Parse(seAdelanto.Value.ToString());
                    ut.Cotizacion.Actualizar(cot);
                    ut.Grabar();
                }
                cpSaveCosto.JSProperties["cpMensajeResult"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                cpSaveCosto.JSProperties["cpMensajeResult"] = "Error: " + ex.Message;
            }
        }

        protected void dgCotizacionDetalle_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "IdServicio")
                e.Editor.ClientInstanceName = "ServicioEditor";
            if (e.Column.FieldName != "IdUnidadMedida")
                return;
            var editor = (ASPxComboBox)e.Editor;
            editor.ClientInstanceName = "UnidadMedidaEditor";
            editor.ClientSideEvents.EndCallback = "UnidadMedida_EndCallback";

        }


        protected void cmbUnidadMedida_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            int id;
            if (e.Value == null || !int.TryParse(e.Value.ToString(), out id))
                return;
            ASPxComboBox combo = source as ASPxComboBox;
            using (var db = new UnidadDeTrabajo())
            {
                combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Id(id);
                combo.DataBind();
            }
        }

        protected void cmbUnidadMedida_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            ASPxComboBox combo = source as ASPxComboBox;
            int servicioValue = GetCurrentServicio();
            if (servicioValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Servicio(servicioValue);
                    combo.DataBind();
                }
            }

        }

        private int GetCurrentServicio()
        {
            object id = null;
            if (hf.TryGet("CurrentServicio", out id))
                return Convert.ToInt32(id);
            return -1;
        }

        protected void cpUpdateFecha_Callback(object sender, CallbackEventArgsBase e)
        {
            using (var bd = new UnidadDeTrabajo())
            {
                Cotizacion cot = bd.Cotizacion.ObtenerPorId(int.Parse(NumeroCotizacion));
                cot.FechaEntrega = DateTime.Parse(e.Parameter.ToString());
                bd.Cotizacion.Actualizar(cot);
                bd.Grabar();
                cpUpdateFecha.JSProperties["cpUpdateFecha"] = "Fecha de Entrega Actualizada!";
            }
           deFechaEntrega.Value = DateTime.Parse(e.Parameter.ToString());
        }
    }
}
using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Linq;

namespace Fay_System
{
    public partial class OrdenesVenta : System.Web.UI.Page
    {
        string NumeroOrdenVenta = "";
        protected void Page_Load(object sender, EventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            NumeroOrdenVenta = Request.QueryString["Id"];
            txtPrecioDolar.Text = wu.ObenerPrecioDolar().ToString();
            deFechaEntrega.Value = DateTime.Today;
            cargarOrdenVentaes();
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
            if (NumeroOrdenVenta == "Nuevo")
            {
                //rbOpciones.Value = 1;
                seAdelanto.ClientEnabled = true;
                btnNewAdelanto.ClientEnabled = false;
                hfIdOrdenVenta["IdOrdenVenta"] = -1;
                dgOrdenVentaDetalle.DataSource = wu.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(0, 1);
                dgOrdenVentaDetalle.DataBind();

                dgSalidaMaterialDetalle.DataSource = wu.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(0, 2);
                dgSalidaMaterialDetalle.DataBind();
                pcEditorOrdenesVenta.ShowOnPageLoad = true;
            }
            if (NumeroOrdenVenta != null && NumeroOrdenVenta != "Nuevo")
            {
                hfIdOrdenVenta["IdOrdenVenta"] = NumeroOrdenVenta;
                if (int.Parse(NumeroOrdenVenta) > 0)
                {
                    seAdelanto.ClientEnabled = false;
                    btnNewAdelanto.ClientEnabled = true;
                    int?[] estateBad = { 40, 48 };
                    OrdenVenta cot = new OrdenVenta();
                    using (var bd = new UnidadDeTrabajo())
                    {
                        cot = bd.OrdenVenta.ObtenerPorId(int.Parse(NumeroOrdenVenta));
                        deFechaEntrega.Value = cot.FechaEntrega;
                        if (cot.TipoOrdenVenta == "Orden Venta Directa") cmbTipoOrden.Value = 2;
                        else cmbTipoOrden.Value = 1;
                        cmbTipoOrden.ReadOnly = true;
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
                        seCostoTotal.Value = cot.CostoTotal;
                        seAdelanto.Value = cot.AdelantoPago == null ? 0 : cot.AdelantoPago;
                        seSaldoOrden.Value = cot.CostoTotal - (cot.AdelantoPago == null ? 0 : cot.AdelantoPago);
                        if (estateBad.Contains(cot.IdEstado))
                        {
                            dgOrdenVentaDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                            dgOrdenVentaDetalle.Columns[0].Visible = false;

                            dgSalidaMaterialDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                            dgSalidaMaterialDetalle.Columns[0].Visible = false;

                            deFechaEntrega.ClientEnabled = false;

                            btnNewAdelanto.ClientEnabled = false;
                        }
                        hfEstadoOv.Set("Estado", cot.IdEstado);

                        if (cot.TipoOrdenVenta == "Orden Venta Directa")
                        {
                            dgSalidaMaterialDetalle.DataSource = wu.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(int.Parse(NumeroOrdenVenta), 2);
                            dgSalidaMaterialDetalle.DataBind();
                        }
                        else
                        {
                            dgOrdenVentaDetalle.DataSource = wu.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(int.Parse(NumeroOrdenVenta), 1);
                            dgOrdenVentaDetalle.DataBind();
                        }
                    }
                    txtApelNomRazSoc.ClientEnabled = false;
                    txtRucDni.ClientEnabled = false;
                    rbOpciones.ClientEnabled = false;
                }
                pcEditorOrdenesVenta.ShowOnPageLoad = true;
            }

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 19) == true)
                    {
                        btnBuscarPersonas.ClientEnabled = false;
                        addOrdenVentaes.ClientEnabled = false;
                        dgOrdenVentaDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                        dgOrdenVentaDetalle.Columns[0].Visible = false;

                        dgSalidaMaterialDetalle.SettingsEditing.Mode = DevExpress.Web.GridViewEditingMode.Inline;
                        dgSalidaMaterialDetalle.Columns[0].Visible = false;
                    }
                }
            }
        }
        protected void cargarOrdenVentaes()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgOrdenesVenta.DataSource = db.OrdenVenta.ObtenerListaOrdenesVenta();
                dgOrdenesVenta.DataBind();
            }
        }
        protected void addOrdenVentaes_Click(object sender, EventArgs e)
        {
            string url = "OrdenesVenta.aspx?Id=Nuevo";
            Response.Redirect(url);
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje(" + mensaje + ");</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgOrdenVentaDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {

            try
            {
                NumeroOrdenVenta = Request.QueryString["Id"];
                using (var db = new UnidadDeTrabajo())
                {
                    if (NumeroOrdenVenta == "Nuevo")
                    {
                        int? idClienteN = null, IdClienteJ = null;
                        if (int.Parse(rbOpciones.Value.ToString()) == 1) { idClienteN = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        if (int.Parse(rbOpciones.Value.ToString()) == 2) { IdClienteJ = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        OrdenVenta Cot = new OrdenVenta
                        {
                            Fecha = DateTime.Now,
                            FechaCreacion = DateTime.Now,
                            IdClienteNatural = idClienteN,
                            IdClienteJuridico = IdClienteJ,
                            IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                            TipoOrdenVenta = "Orden Venta - Orden Trabajo",
                            DocumentoReferencia = "",
                            IdEstado = 39,
                            FechaEntrega = DateTime.Parse(deFechaEntrega.Value.ToString())
                        };
                        db.OrdenVenta.Insertar(Cot);
                        db.Grabar();

                        if (!string.IsNullOrEmpty(seAdelanto.Text))
                        {
                            AdelantosOrdenVenta ad = new AdelantosOrdenVenta
                            {
                                Fecha = DateTime.Now,
                                IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                                Monto = decimal.Parse(seAdelanto.Text),
                                Motivo = "Al crear la orden de venta",
                                IdOrdenVenta = Cot.Id
                            };
                            db.AdelantosOrdenVenta.Insertar(ad);
                            db.Grabar();
                        }

                        foreach (var item in e.InsertValues)
                        {
                            db.OrdenVentaDetalle.InsertarValoresOrdenVentaDetalle(item.NewValues, Cot.Id, decimal.Parse(txtPrecioDolar.Text));
                        }
                        NumeroOrdenVenta = Cot.Id.ToString();
                        string url = "OrdenesVenta.aspx?Id=" + NumeroOrdenVenta;
                        Response.RedirectLocation = url;
                    }
                    else
                    {
                        foreach (var item in e.InsertValues)
                        {
                            db.OrdenVentaDetalle.InsertarValoresOrdenVentaDetalle(item.NewValues, int.Parse(NumeroOrdenVenta.ToString()), decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.UpdateValues)
                        {
                            db.OrdenVentaDetalle.ActualizarOrdenVentaDetalle(item.Keys, item.NewValues, decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.DeleteValues)
                        {
                            db.OrdenVentaDetalle.EliminarOrdenVentaDetalle(item.Keys);
                        }
                    }
                    dgOrdenVentaDetalle.DataSource = db.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(int.Parse(NumeroOrdenVenta), 1);
                    dgOrdenVentaDetalle.DataBind();
                }
                dgOrdenVentaDetalle.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                dgOrdenVentaDetalle.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void dgOrdenVentaes_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    string url = "OrdenesVenta.aspx?Id=" + int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.RedirectLocation = url;
                    break;
                case "Anular":
                    OrdenVenta Cot_anular = wu.OrdenVenta.ObtenerPorId(int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (Cot_anular.IdEstado == 48) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido facturada";
                    else if (Cot_anular.IdEstado == 40) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido Anulada";
                    else if (Cot_anular.IdEstado == 59) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya es una Orden de Trabajo";
                    else
                    {
                        Cot_anular.IdEstado = 40;
                        wu.OrdenVenta.Actualizar(Cot_anular);
                        wu.Grabar();
                        cargarOrdenVentaes();
                        dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación realizada con éxito";
                    }
                    break;
                case "btnVender":
                    OrdenVenta Cot_vender = wu.OrdenVenta.ObtenerPorId(int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (Cot_vender.IdEstado == 48) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido facturada";
                    else if (Cot_vender.IdEstado == 40) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido Anulada";
                    else if (Cot_vender.IdEstado == 59) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya es una Orden de Trabajo";
                    else
                    {
                        if (wu.OrdenVentaDetalle.ContarDetalleOrdenVentaMayorStock(int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString())) == 0)
                        {
                            Cot_vender.IdEstado = 48;
                            wu.OrdenVenta.Actualizar(Cot_vender);
                            try
                            {
                                wu.Grabar();
                                dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación realizada con éxito";
                            }
                            catch (Exception ex) { dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "error:" + ex.InnerException.Message; }
                            cargarOrdenVentaes();
                        }
                        else
                            dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: No hay suficientes unidades en stock";
                    }
                    break;
                case "btnToOt":
                    OrdenVenta ordenv = wu.OrdenVenta.ObtenerPorId(int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (ordenv.IdEstado == 48) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido facturada";
                    else if (ordenv.IdEstado == 40) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya ha sido Anulada";
                    else if (ordenv.IdEstado == 59) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: La orden de venta ya es una Orden de Trabajo";
                    else if (ordenv.TipoOrdenVenta.Contains("Directa")) dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación denegada: Este tipo de orden de venta no puede convertirse en orden de trabajo";
                    else
                    {
                        try
                        {
                            if (wu.OrdenVenta.ConvertirOrdenVenta_OrdenTrabajo(ordenv.Id, Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1) == "")
                            {
                                ordenv.IdEstado = 59;
                                wu.OrdenVenta.Actualizar(ordenv);
                                wu.Grabar();
                                cargarOrdenVentaes();
                                dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Operación realizada correctamente";
                            }

                        }
                        catch (Exception ex)
                        {
                            dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "Error: " + ex.Message;
                        }
                    }
                    break;
                case "showReport":
                    OrdenVenta ov = wu.OrdenVenta.ObtenerPorId(int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (ov.IdEstado != 48)
                    {
                        dgOrdenesVenta.JSProperties["cpOperacionesGrid"] = "La orden de venta " + ov.Id + " aún no tiene comprobante";
                    }
                    else
                    {
                        int IdCv = wu.ComprobanteVenta.ObtenerComprobanteId_OrdenVenta(ov.Id);
                        ComprobanteVenta cv = wu.ComprobanteVenta.ObtenerPorId(IdCv);
                        switch (cv.IdTipoDocumento)
                        {
                            case 1: //Factura
                                Session["ItemClickeado"] = "Factura";
                                break;
                            case 2: //Boleta
                                Session["ItemClickeado"] = "Boleta";
                                break;
                            case 3: //TicketVenta
                                Session["ItemClickeado"] = "TicketVenta";
                                break;
                        }
                        dgOrdenesVenta.JSProperties["cpRedireccion"] = "Reporte.aspx?cv=" + IdCv;
                    }
                    break;
                case "showProforma":
                    Session["ItemClickeado"] = "Proforma";
                    dgOrdenesVenta.JSProperties["cpRedireccion"] = "Reporte.aspx?ovp=" + int.Parse(dgOrdenesVenta.GetRowValues(e.VisibleIndex, "Id").ToString());
                    break;
            }
        }

        protected void dgOrdenVentaDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (NumeroOrdenVenta != null && NumeroOrdenVenta != "Nuevo")
            {
                NumeroOrdenVenta = Request.QueryString["Id"];
                if (NumeroOrdenVenta != null)
                {
                    using (var db = new UnidadDeTrabajo())
                    {
                        int? estadoOv = db.OrdenVenta.ObtenerEstadoOrdenVenta(int.Parse(NumeroOrdenVenta));
                        if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.New && estadoOv == 59)
                            e.Visible = false;
                    }
                }

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

        protected void dgOrdenesVenta_CustomButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCustomButtonEventArgs e)
        {
            if (e.ButtonID == "btnToOt" || e.ButtonID == "btnVender" || e.ButtonID == "Anular")
            {
                using (var ut = new UnidadDeTrabajo())
                {
                    if (Session["IdUserActive"] != null)
                    {
                        if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 19) == true)
                        {
                            e.Visible = DevExpress.Utils.DefaultBoolean.False;
                        }
                    }
                }
            }
        }

        protected void cpSaveAdelanto_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            try
            {
                var sumAd = wu.AdelantosOrdenVenta.ObtenerSaldo_x_OrdenVenta(int.Parse(NumeroOrdenVenta));
                if (decimal.Parse(seMonto.Text) > sumAd)
                {
                    cpSaveAdelanto.JSProperties["cpMensajeResult"] = "El adelanto que intenta registrar supera el total de saldo!";
                }
                else
                {
                    AdelantosOrdenVenta ad = new AdelantosOrdenVenta
                    {
                        Fecha = DateTime.Now,
                        IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                        Monto = decimal.Parse(seMonto.Text),
                        Motivo = txtObserv.Text,
                        IdOrdenVenta = int.Parse(NumeroOrdenVenta)
                    };

                    wu.AdelantosOrdenVenta.Insertar(ad);
                    wu.Grabar();
                    cpSaveAdelanto.JSProperties["cpMensajeResult"] = "Operación realizada correctamente";
                }
            }
            catch (Exception ex)
            {
                cpSaveAdelanto.JSProperties["cpMensajeResult"] = "Error: " + ex.Message;
            }
            //    OrdenVenta ov = wu.OrdenVenta.ObtenerPorId(int.Parse(e.Parameter.Split('|')[0]));
            //    ov.CostoTotal = decimal.Parse(e.Parameter.Split('|')[1]);
            //    ov.AdelantoPago = decimal.Parse(e.Parameter.Split('|')[2]);
            //    wu.OrdenVenta.Actualizar(ov);
            //    wu.Grabar();

            //    cpSaveCosto.JSProperties["cpMensajeResult"] = "Operación realizada con éxito";
            //}
        }

        protected void cpEmitirComprobante_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            switch (int.Parse(e.Parameter))
            {
                case 1:
                    dtpFecha.Value = DateTime.Today;
                    dtpFechaVencimiento.Value = DateTime.Today;
                    using (var db = new UnidadDeTrabajo())
                    {
                        OrdenVenta ov = db.OrdenVenta.ObtenerPorId(int.Parse(hfIdOV.Get("IdOV").ToString()));
                        if (ov.IdClienteNatural > 0)
                        {
                            Cliente cl = db.Cliente.ObtenerPorId(ov.IdClienteNatural);
                            Persona p = db.Persona.ObtenerPorId(cl.IdPersona);
                            lblPersona.Value = p.ApellidoPaterno + " " + p.ApellidoMaterno + ", " + p.Nombres;
                            cbTipoDocumento.Value = 2;
                            cbTipoPago.Value = 1;
                            hfIdOV.Set("IdOV", ov.Id);
                            hfIdPersona.Set("IdPersona", p.Id);
                            hfRuc.Set("RUC", p.Ruc);
                        }
                        else
                        {
                            Empresa em = db.Empresa.ObtenerPorId(ov.IdClienteJuridico);
                            Persona p = db.Persona.ObtenerPorId(em.IdPersona);
                            lblPersona.Value = p.RazonSocial;
                            cbTipoDocumento.Value = 1;
                            cbTipoPago.Value = 1;
                            hfIdOV.Set("IdOV", ov.Id);
                            hfIdPersona.Set("IdPersona", p.Id);
                            hfRuc.Set("RUC", p.Ruc);
                        }
                        decimal tot = db.OrdenVentaDetalle.ObtenerTotalOrdenVenta(ov.Id);
                        txtSubTotalTicket.Value = Math.Round((double)tot / 1.18, 2);
                        txtIGV.Value = Math.Round(((double)tot / 1.18) * 0.18, 2);
                        txtTotalTicket.Value = tot;
                        txtDescuento.Value = 0;
                        if (ov.TipoOrdenVenta.Contains("Trabajo"))
                            btnAceptar2.ClientEnabled = ov.IdEstado == 59 ? true : false;
                        else
                            btnAceptar2.ClientEnabled = ov.IdEstado == 39 ? true : false;
                    }
                    break;
                case 2:
                    try
                    {
                        using (var db = new UnidadDeTrabajo())
                        {
                            ComprobanteVenta cv = new ComprobanteVenta();
                            //{
                            cv.Fecha = DateTime.Now;
                            cv.IdPersona = int.Parse(hfIdPersona.Get("IdPersona").ToString());
                            cv.Serie = int.Parse(cbTipoDocumento.Value.ToString()) == 1 ? "F001" : int.Parse(cbTipoDocumento.Value.ToString()) == 2 ? "B001" : "T001";
                            cv.Numero = 0;
                            cv.Descuento = double.Parse(txtDescuento.Text);
                            cv.Total = double.Parse(txtTotalTicket.Text);
                            cv.IGV = 18;
                            cv.FechaCreacion = DateTime.Now;
                            cv.IdTipoDocumento = int.Parse(cbTipoDocumento.Value.ToString());
                            cv.IdMotivoComprobante = 1;
                            cv.IdTipoPago = int.Parse(cbTipoPago.Value.ToString());
                            cv.IdCaja = 1;
                            cv.Observacion = "Emitido";
                            cv.IdEstado = 65;
                            cv.IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                            cv.IdOrdenVenta = int.Parse(hfIdOV.Get("IdOV").ToString());

                            //};
                            db.ComprobanteVenta.Insertar(cv);
                            db.Grabar();
                        }

                        cpEmitirComprobante.JSProperties["cpEmisionCV"] = "OK";
                    }
                    catch (Exception ex)
                    {
                        cpEmitirComprobante.JSProperties["cpEmisionCV"] = "Error: " + ex.Message;
                    }
                    break;
            }

        }

        protected void dgOrdenVentaDetalle_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
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

        protected void dgSalidaMaterialDetalle_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                NumeroOrdenVenta = Request.QueryString["Id"];
                using (var db = new UnidadDeTrabajo())
                {
                    if (NumeroOrdenVenta == "Nuevo")
                    {
                        int? idClienteN = null, IdClienteJ = null;
                        if (int.Parse(rbOpciones.Value.ToString()) == 1) { idClienteN = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        if (int.Parse(rbOpciones.Value.ToString()) == 2) { IdClienteJ = int.Parse(hfIdCliente["IdPersona"].ToString()); }
                        OrdenVenta Cot = new OrdenVenta
                        {
                            Fecha = DateTime.Now,
                            FechaCreacion = DateTime.Now,
                            IdClienteNatural = idClienteN,
                            IdClienteJuridico = IdClienteJ,
                            IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                            TipoOrdenVenta = "Orden Venta Directa",
                            DocumentoReferencia = "",
                            IdEstado = 39,
                        };
                        db.OrdenVenta.Insertar(Cot);
                        db.Grabar();
                        foreach (var item in e.InsertValues)
                        {
                            db.OrdenVentaDetalle.InsertarValoresOrdenVentaDetalle(item.NewValues, Cot.Id, decimal.Parse(txtPrecioDolar.Text));
                        }
                        NumeroOrdenVenta = Cot.Id.ToString();
                        string url = "OrdenesVenta.aspx?Id=" + NumeroOrdenVenta;
                        Response.RedirectLocation = url;
                    }
                    else
                    {
                        foreach (var item in e.InsertValues)
                        {
                            db.OrdenVentaDetalle.InsertarValoresOrdenVentaDetalle(item.NewValues, int.Parse(NumeroOrdenVenta.ToString()), decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.UpdateValues)
                        {
                            db.OrdenVentaDetalle.ActualizarOrdenVentaDetalle(item.Keys, item.NewValues, decimal.Parse(txtPrecioDolar.Text));
                        }
                        foreach (var item in e.DeleteValues)
                        {
                            db.OrdenVentaDetalle.EliminarOrdenVentaDetalle(item.Keys);
                        }
                    }
                    dgSalidaMaterialDetalle.DataSource = db.OrdenVentaDetalle.ObtenerDetalleOrdenVenta(int.Parse(NumeroOrdenVenta), 2);
                    dgSalidaMaterialDetalle.DataBind();
                }
                dgSalidaMaterialDetalle.JSProperties["cpOperacionGrid"] = "Operación realizada con éxito";
            }
            catch (Exception ex)
            {
                dgSalidaMaterialDetalle.JSProperties["cpOperacionGrid"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void cpGetPrecioMaterial_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioMaterial.JSProperties["cpPrecioS"] = ut.Material.ObtenerPrecioMaterial(int.Parse(e.Parameter.Split('|')[0]), int.Parse(e.Parameter.Split('|')[1])).ToString();
            }
        }

        protected void cpGeStockMaterial_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var ut = new UnidadDeTrabajo())
            {
                cpGetPrecioMaterial.JSProperties["cpStockM"] = ut.Material.ObtenerStockMaterial(int.Parse(e.Parameter.ToString().Split('|')[0]), int.Parse(e.Parameter.ToString().Split('|')[1])).ToString();
            }
        }
        protected void dgSalidaMaterialDetalle_CellEditorInitialize(object sender, ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName == "IdAlmacen")
                e.Editor.ClientInstanceName = "AlmacenEditor";
            else if (e.Column.FieldName == "IdMaterial")
            {
                var editor = (ASPxComboBox)e.Editor;
                editor.ClientInstanceName = "MaterialEditor";
                editor.ClientSideEvents.EndCallback = "Material_EndCallback";
            }
            else if (e.Column.FieldName == "IdUnidadMedida")
            {
                var editor1 = (ASPxComboBox)e.Editor;
                editor1.ClientInstanceName = "UnidadMedidaMEditor";
                editor1.ClientSideEvents.EndCallback = "UnidadMedidaM_EndCallback";
            }
            else return;
        }

        protected void cmbMaterial_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
        {
            int id;
            if (e.Value == null || !int.TryParse(e.Value.ToString(), out id))
                return;
            ASPxComboBox combo = source as ASPxComboBox;
            using (var db = new UnidadDeTrabajo())
            {
                combo.DataSource = db.Material.ObtenerMaterial_x_Id(id);
                combo.DataBind();
            }
        }

        protected void cmbMaterial_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            ASPxComboBox combo = source as ASPxComboBox;
            int almacenValue = GetCurrentAlmacen();
            if (almacenValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.Material.Obtener_DTOMaterial_x_idAlmacen(almacenValue);
                    combo.DataBind();
                }
            }

        }

        protected void cmbUnidadMedidaM_ItemRequestedByValue(object source, ListEditItemRequestedByValueEventArgs e)
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

        protected void cmbUnidadMedidaM_ItemsRequestedByFilterCondition(object source, ListEditItemsRequestedByFilterConditionEventArgs e)
        {
            ASPxComboBox combo = source as ASPxComboBox;
            int materialValue = GetCurrentMaterial();
            if (materialValue > -1)
            {
                using (var db = new UnidadDeTrabajo())
                {
                    combo.DataSource = db.UnidadMedida.ObtenerUnidadesMedida_x_Material(materialValue);
                    combo.DataBind();
                }
            }

        }

        private int GetCurrentAlmacen()
        {
            if (hf.TryGet("CurrentAlmacen", out object id))
                return Convert.ToInt32(id);
            return -1;
        }

        private int GetCurrentMaterial()
        {
            if (hf1.TryGet("CurrentMaterial", out object id))
                return Convert.ToInt32(id);
            return -1;
        }

        protected void cpUpdateFecha_Callback(object sender, CallbackEventArgsBase e)
        {
            using (var bd = new UnidadDeTrabajo())
            {
                OrdenVenta ov = bd.OrdenVenta.ObtenerPorId(int.Parse(NumeroOrdenVenta));
                ov.FechaEntrega = DateTime.Parse(e.Parameter.ToString());
                bd.OrdenVenta.Actualizar(ov);
                bd.Grabar();
                cpUpdateFecha.JSProperties["cpUpdateFecha"] = "Fecha de Entrega Actualizada!";
            }
            deFechaEntrega.Value = DateTime.Parse(e.Parameter.ToString());
        }

        protected void cpLoadAdelantos_Callback(object sender, CallbackEventArgsBase e)
        {
            IdOV.Value = NumeroOrdenVenta;
            fecha.Value = DateTime.Now;
            using (var bd = new UnidadDeTrabajo())
            {
                seSaldoFinOrden.Value = bd.AdelantosOrdenVenta.ObtenerSaldo_x_OrdenVenta(int.Parse(NumeroOrdenVenta));
            }
            seMonto.Value = null;
            txtObserv.Value = null;
        }
    }
}
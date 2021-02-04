using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class OrdenesTrabajo : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            cargarOrdenesTrabajo();
            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 20) == true)
                    {
                        btnACeptarMain.ClientEnabled = false;
                        addOrdenTrabajo.ClientEnabled = false;
                        //dgBodegaInventarioCorte.SettingsEditing.Mode = GridViewEditingMode.Inline;
                        dgPrensaOrdenTrabajo.SettingsEditing.Mode = GridViewEditingMode.Inline;
                        hlGuardarDatos.ClientEnabled = false;
                    }
                }
            }

            //ClientScript.RegisterStartupScript(Page.GetType(), "javascript", "javascript:LanzarMensaje('" + "mensaje prueba" + "');", true);
        }
        protected void cargarOrdenesTrabajo()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgOrdenesTrabajo.DataSource = db.OrdenTrabajo.ObtenerListaOrdenesTrabajo();
                dgOrdenesTrabajo.DataBind();
            }
        }
        protected void addOrdenTrabajo_Click(object sender, EventArgs e)
        {
            pcEditorOrdenesTrabajo.ShowOnPageLoad = true;
            deFechaEmision.Value = DateTime.Today;
            //deFechaEntregaO.Value = DateTime.Today;
            deFechaEntregaF.Value = DateTime.Today;
            lblOperacion.Text = "1";
            lblIdOrden.Text = "0";
            //seNumOrdenado.Value = null;
            seTotalPlacas.Value = null;
            //seNumPlacas.Value = null;
            seNumSelecciones.Value = null;
            //seNumPlacas.Value = null;
            cmbCliente.SelectedIndex = -1;
            cmbEjecutivo.SelectedIndex = -1;
            //cmbEstado.Value = 43;
            cbxCanson.Checked = false;
            cbxCTP.Checked = false;
            //cbxFullColor.Checked = false;
            txtObservacionesMain.Value = null;
            cmbOperador.Text = null;
            txtTrabajo.Text = null;
            //txtLiniaje.Text = null;
            //txtMaquina.Text = null;
            //txtColores.Text = null;
            //txtIColor.Text = null;
            //txtTamAbierto.Text = null;
            //sePagInteriores.Value = null;
            //sePagPortada.Value = null;
            //seSaldoOrden.Value = 0;
            //seCostoTotal.Value = 0;
            //seAdelanto.Value = 0;
            seCantPlieg.Value = 0;
            seCantResmas.Value = 0;
            seContacto.Value = null;
            txtDescPli.Value = null;
            txtxDescResmas.Value = null;
            txtMedPli.Value = null;
            txtMedResmas.Value = null;
            txtDemPli.Value = null;
            txtDemResmas.Value = null;
            txtTamCortPli.Value = null;
            txtTamCortResmas.Value = null;

            rbColores.Value = null;
        }

        protected void dgOrdenesTrabajo_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    //dgRecepcionDetalle.Visible = true;
                    int?[] estateBad = { 44, 64 };

                    lblOperacion.Text = "2";
                    OrdenTrabajo ot = wu.OrdenTrabajo.ObtenerPorId(int.Parse(dgOrdenesTrabajo.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    lblIdOrden.Text = ot.IdOrdenTrabajo.ToString();
                    deFechaEmision.Value = ot.FechaEmision;
                    //deFechaEntregaO.Value = ot.FechaEntregaO;
                    deFechaEntregaF.Value = ot.FechaEntregaF;
                    txtTrabajo.Value = ot.Trabajo;
                    cmbEjecutivo.Value = ot.IdEjecutivo;
                    if (ot.IdClienteNatural > 0)
                    {
                        cmbCliente.DataSource = wu.Cliente.ListadoClientesDatosGenerales();
                        cmbCliente.ValueField = "IdCliente";
                        cmbCliente.TextField = "ApelNom";
                        cmbCliente.DataBind();

                    }
                    else
                    {
                        cmbCliente.DataSource = wu.Empresa.ObtenerListaEmpresas();
                        cmbCliente.ValueField = "Id";
                        cmbCliente.TextField = "RazonSocial";
                        cmbCliente.DataBind();
                    }
                    cmbCliente.Value = ot.IdClienteNatural > 0 ? ot.IdClienteNatural : ot.IdClienteJuridico;
                    sePlaUnCol.Value = ot.NumeroPlacasUnColor;
                    seTotalPlacas.Value = ot.TotalPlacas;
                    //seNumOrdenado.Value = ot.NumeroOrdenado;
                    //txtTamAbierto.Value = ot.TamañoAbierto;
                    //txtLiniaje.Value = ot.Liniaje;
                    //cmbEstado.ClientEnabled = false;
                    //cmbEstado.Value = ot.IdEstado;
                    //txtMaquina.Value = ot.Maquina;
                    //sePagPortada.Value = ot.PagPortada;
                    //sePagInteriores.Value = ot.PaginaInteriores;
                    //txtColores.Value = ot.Colores;
                    //txtIColor.Value = ot.IColor;
                    seNumSelecciones.Value = ot.NumeroSelecciones;
                    //cbxFullColor.Value = ot.FullColor;
                    //cbxPaneles.Value = ot.Paneles;
                    cbxCTP.Value = ot.Ctp;
                    cbxCanson.Value = ot.Canson;
                    txtObservacionesMain.Value = ot.Observaciones;
                    cmbOperador.Text = ot.Operadores;
                    //cmbOperadorB.Text = ot.OperadoresBodegaInventario;
                    //txtObservacionesB.Text = ot.ComentariosBodegaInventario;
                    seContacto.Value = ot.Contacto;
                    cmbOperadorP.Text = ot.OperadoresPrensa;
                    txtObservacionesP.Text = ot.ComentariosPrensa;
                    cmbOperadorPP.Text = ot.OperadoresPosPrensa;
                    txtObservacionesPP.Text = ot.ComentariosPosPrensa;
                    rbColores.Value = ot.Colores;
                    seCantPlieg.Value = ot.CantidadPliegos;
                    seCantResmas.Value = ot.CantidadResmas;
                    txtDescPli.Value = ot.DescripcionPliegos;
                    txtxDescResmas.Value = ot.DescripcionResmas;
                    txtDemPli.Value = ot.DemasiaPliegos;
                    txtDemResmas.Value = ot.DemasiaResmas;
                    txtMedPli.Value = ot.MedidaPliegos;
                    txtMedResmas.Value = ot.MedidaResmas;
                    txtTamCortPli.Value = ot.TamañoCortePliego;
                    txtTamCortResmas.Value = ot.TamañoCorteResmas;

                    //seCostoTotal.Value = ot.CostoTotalOrden;
                    //seAdelanto.Value = ot.AdelantoPago;
                    //seSaldoOrden.Value = ot.CostoTotalOrden - ot.AdelantoPago;

                    if (estateBad.Contains(ot.IdEstado)) btnACeptarMain.ClientEnabled = false;
                    else btnACeptarMain.ClientEnabled = true;

                    PosPrensaOrdenTrabajo ppot = wu.PosPrensaOrdenTrabajo.ObtenerPosPrensaOrdenTrabajo_IdOrden(ot.IdOrdenTrabajo);
                    cbxAl.Value = ppot.Al;
                    cbxAnillado.Value = ppot.Anillado;
                    cbxBarnizado.Value = ppot.Barnizado;
                    cbxBrillante.Value = ppot.Brillante;
                    cbxBrillante1.Value = ppot.Brillante1;
                    cbxCompaginado.Value = ppot.Compaginado;
                    cbxDel.Value = ppot.Del;
                    cbxDobleRing.Value = ppot.DobleRing;
                    cbxEncolado.Value = ppot.Encolado;
                    cbxEngrampado.Value = ppot.Engrampado;
                    cbxMate.Value = ppot.Mate;
                    cbxMate1.Value = ppot.Mate1;
                    cbxNumerado.Value = ppot.Numerado;
                    cbxPerforado.Value = ppot.Perforado;
                    cbxPlastificado.Value = ppot.Plastificado;
                    cbxRefilado.Value = ppot.Refilado;
                    cbxTira.Value = ppot.Tira;
                    cbxTira1.Value = ppot.Tira1;
                    cbxTiraRet.Value = ppot.TiraRetira;
                    cbxTiraRet1.Value = ppot.RetiraRetira1;
                    cbxTroquelado.Value = ppot.Troquelado;

                    //CargarDatosBodegaInventario(ot.IdOrdenTrabajo);
                    //CargarDatosPrensaOrdenTrabajo(ot.IdOrdenTrabajo);

                    AutoCorriativoOrdenTrabajo aot = wu.AutoCorriativoOrdenTrabajo.ObtenerAutocorriativo_IdOrden(ot.IdOrdenTrabajo);
                    txtCantidadAut.Value = aot.CantidadAut;
                    txtHojasAut.Value = aot.HojasAut;
                    cbxCB.Value = aot.CbAUt;
                    txtCB.Value = aot.ValorCbAut;
                    cbxCF.Value = aot.cbCfAut;
                    txtCF.Value = aot.ValorCfAut;
                    cbxCFB.Value = aot.CfbAut;
                    txtCFB.Value = aot.ValorCfbAut;
                    cbxCFB1.Value = aot.CfbAut1;
                    txtCFB1.Value = aot.ValorCfbAut1;
                    cbxCFB1.Value = aot.CfbAut2;
                    txtCFB1.Value = aot.ValorCfbAut2;

                    pcEditorOrdenesTrabajo.ShowOnPageLoad = true;
                    break;
                case "Anular":
                    OrdenTrabajo ordenTrabajo = wu.OrdenTrabajo.ObtenerPorId(int.Parse(dgOrdenesTrabajo.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    OrdenVenta ov = wu.OrdenVenta.ObtenerPorId(wu.OrdenTrabajo.ObtenerOrdenVentaId_x_IdOrdenTrabajo(ordenTrabajo.IdOrdenTrabajo));
                    if (ov.IdEstado == 48)
                    {
                        int IdCv = wu.ComprobanteVenta.ObtenerComprobanteId_OrdenVenta(ov.Id);
                        int IdNc = wu.ComprobanteVenta.ObtenerNotasCreaditoAO_x_IdComprobante(IdCv);
                        if (IdNc > 0)
                        {
                            ordenTrabajo.IdEstado = 44;
                            wu.OrdenTrabajo.Actualizar(ordenTrabajo);
                            wu.Grabar();
                            cargarOrdenesTrabajo();
                        }
                        else
                        {
                            MostrarMensajes("Operación denegada: ya se ha facturado la orden de venta asociada a esta orden de trabajo");
                        }
                    }
                    else
                    {
                        ordenTrabajo.IdEstado = 44;
                        wu.OrdenTrabajo.Actualizar(ordenTrabajo);
                        wu.Grabar();
                        cargarOrdenesTrabajo();
                    }
                    break;
                case "showReport":
                    Session["ItemClickeado"] = "OrdenTrabajo";
                    string url = "Reporte.aspx?ot=" + int.Parse(dgOrdenesTrabajo.GetRowValues(e.VisibleIndex, "Id").ToString());
                    Response.Write("<script>window.open('" + url + "','_blank');</script>");
                    break;
                case "entregarOrden":
                    OrdenTrabajo ort = wu.OrdenTrabajo.ObtenerPorId(int.Parse(dgOrdenesTrabajo.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    if (ort.IdEstado != 64)
                    {
                        ort.IdEstado = 64;
                        wu.OrdenTrabajo.Actualizar(ort);
                        wu.Grabar();
                    }
                    else
                        MostrarMensajes("Orden de Trabajo Finalizada");
                    cargarOrdenesTrabajo();
                    break;
            }
        }

        private void CargarDatosPrensaOrdenTrabajo(int idOrdenTrabajo)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            dgPrensaOrdenTrabajo.DataSource = wu.PrensaOrdenTrabajo.ObtenerDatosPrensa_IdOT(idOrdenTrabajo);
            dgPrensaOrdenTrabajo.DataBind();
        }

        private void CargarDatosBodegaInventario(int idOrdenTrabajo)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();

            //dgBodegaInventarioCorte.DataSource = wu.BodegaInventarioCorte.ObtenerDatosBodegaInventario_IdOT(idOrdenTrabajo);
            //dgBodegaInventarioCorte.DataBind();
        }

        protected void dgRecepcionDetalle_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update && e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:MostrarResultados('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void generic_CellEditorInitialize(object sender, DevExpress.Web.ASPxGridViewEditorEventArgs e)
        {
            if (e.Column.FieldName != "nothing") { e.Editor.ReadOnly = false; }
        }

        protected void btnACeptarMain_Click(object sender, EventArgs e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    if (lblOperacion.Text == "1")
                    {
                        OrdenTrabajo ot = new OrdenTrabajo
                        {
                            FechaEmision = DateTime.Now,
                            FechaEntregaO = DateTime.Now,
                            FechaEntregaF = DateTime.Parse(deFechaEntregaF.Value.ToString()),
                            Trabajo = txtTrabajo.Text,
                            IdEjecutivo = int.Parse(cmbEjecutivo.Value.ToString()),
                            IdClienteNatural = int.Parse(cmbCliente.Value.ToString()),
                            NumeroSelecciones = int.Parse(seNumSelecciones.Value.ToString()),
                            //NumeroPlacasUnColor = int.Parse(seNumPlacas.Value.ToString()),
                            TotalPlacas = int.Parse(seTotalPlacas.Value.ToString()),
                            //NumeroOrdenado = int.Parse(seNumOrdenado.Value.ToString()),
                            //Maquina = txtMaquina.Text,
                            //PagPortada = int.Parse(sePagPortada.Value.ToString()),
                            //PaginaInteriores = int.Parse(sePagInteriores.Value.ToString()),
                            //TamañoAbierto = txtTamAbierto.Text,
                            //FullColor = cbxFullColor.Checked ? true : false,
                            //Colores = txtColores.Text,
                            //IColor = txtIColor.Text,
                            //Liniaje = txtLiniaje.Text,
                            //Paneles = cbxPaneles.Checked ? true : false,
                            Observaciones = txtObservacionesMain.Text,
                            Ctp = cbxCTP.Checked ? true : false,
                            Canson = cbxCanson.Checked ? true : false,
                            Operadores = cmbOperador.Text,
                            IdEstado = 43,
                            CantidadPliegos = int.Parse(seCantPlieg.Value.ToString()),
                            DescripcionPliegos = txtDescPli.Text,
                            DemasiaPliegos = txtDemPli.Text,
                            MedidaPliegos = txtMedPli.Text,
                            TamañoCortePliego = txtTamCortPli.Text,
                            CantidadResmas = int.Parse(seCantResmas.Value.ToString()),
                            DescripcionResmas = txtxDescResmas.Text,
                            DemasiaResmas = txtDemResmas.Text,
                            MedidaResmas = txtMedResmas.Text,
                            TamañoCorteResmas = txtTamCortResmas.Text,
                            OperadoresPosPrensa = cmbOperadorPP.Text,
                            ComentariosPosPrensa = txtObservacionesPP.Text,
                            Colores = rbColores.Value.ToString()
                            //CostoTotalOrden = decimal.Parse(seCostoTotal.Value.ToString()),
                            //AdelantoPago = decimal.Parse(seAdelanto.Value.ToString())
                        };
                        db.OrdenTrabajo.Insertar(ot);
                        db.Grabar();

                        PosPrensaOrdenTrabajo ppot = new PosPrensaOrdenTrabajo
                        {
                            IdOrdenTrabajo = ot.IdOrdenTrabajo,
                            Al = int.Parse(cbxAl.Value.ToString()),
                            Anillado = cbxAnillado.Checked,
                            Barnizado = cbxBarnizado.Checked,
                            Brillante = cbxBrillante.Checked,
                            Brillante1 = cbxBrillante1.Checked,
                            Compaginado = cbxCompaginado.Checked,
                            Del = int.Parse(cbxDel.Value.ToString()),
                            DobleRing = cbxDobleRing.Checked,
                            Encolado = cbxEncolado.Checked,
                            Engrampado = cbxEngrampado.Checked,
                            Mate = cbxMate.Checked,
                            Mate1 = cbxMate1.Checked,
                            Numerado = cbxNumerado.Checked,
                            Perforado = cbxPerforado.Checked,
                            Plastificado = cbxPlastificado.Checked,
                            Refilado = cbxRefilado.Checked,
                            Tira = cbxTira.Checked,
                            Tira1 = cbxTira1.Checked,
                            TiraRetira = cbxTiraRet.Checked,
                            RetiraRetira1 = cbxTiraRet1.Checked,
                            Troquelado = cbxTroquelado.Checked,
                        };
                        db.PosPrensaOrdenTrabajo.Insertar(ppot);
                        db.Grabar();
                    }
                    else
                    {
                        OrdenTrabajo ot = db.OrdenTrabajo.ObtenerPorId(int.Parse(lblIdOrden.Text));
                        ot.FechaEmision = DateTime.Now;
                        ot.FechaEntregaO = DateTime.Now;
                        ot.FechaEntregaF = DateTime.Parse(deFechaEntregaF.Value.ToString());
                        ot.Trabajo = txtTrabajo.Text;
                        ot.IdEjecutivo = int.Parse(cmbEjecutivo.Value.ToString());
                        if (ot.IdClienteNatural > 0)
                        {
                            ot.IdClienteNatural = int.Parse(cmbCliente.Value.ToString());
                        }
                        else
                        {
                            ot.IdClienteJuridico = int.Parse(cmbCliente.Value.ToString());
                        }
                        ot.NumeroSelecciones = int.Parse(seNumSelecciones.Value.ToString());
                        ot.NumeroPlacasUnColor = string.IsNullOrEmpty(sePlaUnCol.Text) ? 0 : int.Parse(sePlaUnCol.Value.ToString());
                        ot.TotalPlacas = string.IsNullOrEmpty(seTotalPlacas.Text) ? 0 : int.Parse(seTotalPlacas.Value.ToString());
                        //ot.NumeroOrdenado = string.IsNullOrEmpty(seNumOrdenado.Text) ? 0 : int.Parse(seNumOrdenado.Value.ToString());
                        //ot.Maquina = txtMaquina.Text;
                        //ot.PagPortada = string.IsNullOrEmpty(sePagPortada.Text) ? 0 : int.Parse(sePagPortada.Value.ToString());
                        //ot.PaginaInteriores = string.IsNullOrEmpty(sePagInteriores.Text) ? 0 : int.Parse(sePagInteriores.Value.ToString());
                        //ot.TamañoAbierto = txtTamAbierto.Text;
                        //ot.FullColor = cbxFullColor.Checked ? true : false;
                        //ot.Colores = txtColores.Text;
                        //ot.IColor = txtIColor.Text;
                        //ot.Liniaje = txtLiniaje.Text;
                        //ot.Paneles = cbxPaneles.Checked ? true : false;
                        ot.Observaciones = txtObservacionesMain.Text;
                        ot.Ctp = cbxCTP.Checked ? true : false;
                        ot.Canson = cbxCanson.Checked ? true : false;
                        ot.CantidadPliegos = !string.IsNullOrEmpty(seCantPlieg.Text) ? int.Parse(seCantPlieg.Text) : 0;
                        ot.DescripcionPliegos = txtDescPli.Text;
                        ot.DemasiaPliegos = txtDemPli.Text;
                        ot.MedidaPliegos = txtMedPli.Text;
                        ot.TamañoCortePliego = txtTamCortPli.Text;
                        ot.CantidadResmas = !string.IsNullOrEmpty(seCantResmas.Text) ? int.Parse(seCantResmas.Text) : 0;
                        ot.DescripcionResmas = txtxDescResmas.Text;
                        ot.DemasiaResmas = txtDemResmas.Text;
                        ot.MedidaResmas = txtMedResmas.Text;
                        ot.TamañoCorteResmas = txtTamCortResmas.Text;
                        //ot.IdEstado = int.Parse(cmbEstado.Value.ToString());
                        ot.Operadores = cmbOperador.Text;
                        ot.Colores = rbColores.Value == null? null: rbColores.Value.ToString();
                        //ot.CostoTotalOrden = decimal.Parse(seCostoTotal.Value.ToString());
                        //ot.AdelantoPago = decimal.Parse(seAdelanto.Value.ToString());

                        ot.OperadoresPosPrensa = cmbOperadorPP.Text;
                        ot.ComentariosPosPrensa = txtObservacionesPP.Text;
                        ot.Contacto = seContacto.Text;

                        db.OrdenTrabajo.Actualizar(ot);
                        db.Grabar();

                        PosPrensaOrdenTrabajo ppot = db.PosPrensaOrdenTrabajo.ObtenerPosPrensaOrdenTrabajo_IdOrden(int.Parse(lblIdOrden.Text));
                        ppot.Al = int.Parse(cbxAl.Value.ToString());
                        ppot.Anillado = cbxAnillado.Checked;
                        ppot.Barnizado = cbxBarnizado.Checked;
                        ppot.Brillante = cbxBrillante.Checked;
                        ppot.Brillante1 = cbxBrillante1.Checked;
                        ppot.Compaginado = cbxCompaginado.Checked;
                        ppot.Del = int.Parse(cbxDel.Value.ToString());
                        ppot.DobleRing = cbxDobleRing.Checked;
                        ppot.Encolado = cbxEncolado.Checked;
                        ppot.Engrampado = cbxEngrampado.Checked;
                        ppot.Mate = cbxMate.Checked;
                        ppot.Mate1 = cbxMate1.Checked;
                        ppot.Numerado = cbxNumerado.Checked;
                        ppot.Perforado = cbxPerforado.Checked;
                        ppot.Plastificado = cbxPlastificado.Checked;
                        ppot.Refilado = cbxRefilado.Checked;
                        ppot.Tira = cbxTira.Checked;
                        ppot.Tira1 = cbxTira1.Checked;
                        ppot.TiraRetira = cbxTiraRet.Checked;
                        ppot.RetiraRetira1 = cbxTiraRet1.Checked;
                        ppot.Troquelado = cbxTroquelado.Checked;

                        db.PosPrensaOrdenTrabajo.Actualizar(ppot);
                        db.Grabar();

                        AutoCorriativoOrdenTrabajo aot = db.AutoCorriativoOrdenTrabajo.ObtenerAutocorriativo_IdOrden(int.Parse(lblIdOrden.Text));
                        aot.CantidadAut = txtCantidadAut.Text;
                        aot.HojasAut = txtHojasAut.Text;
                        aot.CbAUt = cbxCB.Checked;
                        aot.ValorCbAut = txtCB.Text;
                        aot.cbCfAut = cbxCF.Checked;
                        aot.ValorCfAut = txtCF.Text;
                        aot.CfbAut = cbxCFB.Checked;
                        aot.ValorCfbAut = txtCFB.Text;
                        aot.CfbAut1 = cbxCFB1.Checked;
                        aot.ValorCfbAut1 = txtCFB1.Text;
                        aot.CfbAut2 = cbxCFB2.Checked;
                        aot.ValorCfbAut2 = txtCFB2.Text;

                        db.AutoCorriativoOrdenTrabajo.Actualizar(aot);
                        db.Grabar();
                    }
                    //

                }
                cargarOrdenesTrabajo();
            }
            catch (Exception ex)
            {
                MostrarMensajes("Ha ocurrido un error: " + ex.Message);
            }
        }

        protected void listBox_DataBound(object sender, EventArgs e)
        {
            //ASPxListBox lb = (ASPxListBox)sender;
            //if(lb.Items.Count > 0)
            //{
            //    lb.Items[0].Selected = true;
            //}
        }

        protected void dgBodegaInventarioCorte_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    OrdenTrabajo ordenTrabajo = db.OrdenTrabajo.ObtenerPorId(int.Parse(lblIdOrden.Text));
                    //ordenTrabajo.OperadoresBodegaInventario = cmbOperadorB.Text;
                    //ordenTrabajo.ComentariosBodegaInventario = txtObservacionesB.Text;
                    db.OrdenTrabajo.Actualizar(ordenTrabajo);
                    db.Grabar();

                    foreach (var item in e.InsertValues)
                    {
                        db.BodegaInventarioCorte.InsertarValoresBodegaInventario(item.NewValues, int.Parse(lblIdOrden.Text.ToString()));
                    }
                    foreach (var item in e.UpdateValues)
                    {
                        db.BodegaInventarioCorte.ActualizarValoresBodegaInventario(item.Keys, item.NewValues);
                    }
                }
                //pcEditorOrdenesTrabajo.ShowOnPageLoad = false;
                //dgBodegaInventarioCorte.JSProperties["cpBodegaInventario"] = "Operación realizada con éxito";
                CargarDatosBodegaInventario(int.Parse(lblIdOrden.Text));
            }
            catch (Exception)
            {
                //dgBodegaInventarioCorte.JSProperties["cpBodegaInventario"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void dgPrensaOrdenTrabajo_BatchUpdate(object sender, DevExpress.Web.Data.ASPxDataBatchUpdateEventArgs e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    OrdenTrabajo ordenTrabajo = db.OrdenTrabajo.ObtenerPorId(int.Parse(lblIdOrden.Text));
                    ordenTrabajo.OperadoresPrensa = cmbOperadorP.Text;
                    ordenTrabajo.ComentariosPrensa = txtObservacionesP.Text;
                    db.OrdenTrabajo.Actualizar(ordenTrabajo);
                    db.Grabar();

                    foreach (var item in e.InsertValues)
                    {
                        db.PrensaOrdenTrabajo.InsertarValoresPrensaOrdenTrabajo(item.NewValues, int.Parse(lblIdOrden.Text.ToString()));
                    }
                    foreach (var item in e.UpdateValues)
                    {
                        db.PrensaOrdenTrabajo.ActualizarValoresPrensaOrden(item.Keys, item.NewValues);
                    }

                }
                //pcEditorOrdenesTrabajo.ShowOnPageLoad = false;
                dgPrensaOrdenTrabajo.JSProperties["cpPrensaOrden"] = "Operación realizada con éxito";
                CargarDatosPrensaOrdenTrabajo(int.Parse(lblIdOrden.Text));
            }
            catch (Exception ex)
            {
                dgPrensaOrdenTrabajo.JSProperties["cpPrensaOrden"] = "Ha ocurrido un error inesperado: " + ex.Message;
            }
            e.Handled = true;
        }

        protected void cpPosPrensa_Callback(object sender, CallbackEventArgsBase e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    PosPrensaOrdenTrabajo ppot = db.PosPrensaOrdenTrabajo.ObtenerPosPrensaOrdenTrabajo_IdOrden(int.Parse(lblIdOrden.Text));
                    ppot.Al = int.Parse(cbxAl.Value.ToString());
                    ppot.Anillado = cbxAnillado.Checked;
                    ppot.Barnizado = cbxBarnizado.Checked;
                    ppot.Brillante = cbxBrillante.Checked;
                    ppot.Brillante1 = cbxBrillante1.Checked;
                    ppot.Compaginado = cbxCompaginado.Checked;
                    ppot.Del = int.Parse(cbxDel.Value.ToString());
                    ppot.DobleRing = cbxDobleRing.Checked;
                    ppot.Encolado = cbxEncolado.Checked;
                    ppot.Engrampado = cbxEngrampado.Checked;
                    ppot.Mate = cbxMate.Checked;
                    ppot.Mate1 = cbxMate1.Checked;
                    ppot.Numerado = cbxNumerado.Checked;
                    ppot.Perforado = cbxPerforado.Checked;
                    ppot.Plastificado = cbxPlastificado.Checked;
                    ppot.Refilado = cbxRefilado.Checked;
                    ppot.Tira = cbxTira.Checked;
                    ppot.Tira1 = cbxTira1.Checked;
                    ppot.TiraRetira = cbxTiraRet.Checked;
                    ppot.RetiraRetira1 = cbxTiraRet1.Checked;
                    ppot.Troquelado = cbxTroquelado.Checked;

                    db.PosPrensaOrdenTrabajo.Actualizar(ppot);
                    db.Grabar();

                    OrdenTrabajo ot = db.OrdenTrabajo.ObtenerPorId(int.Parse(lblIdOrden.Text));
                    ot.OperadoresPosPrensa = cmbOperadorPP.Text;
                    ot.ComentariosPosPrensa = txtObservacionesPP.Text;

                    db.OrdenTrabajo.Actualizar(ot);
                    db.Grabar();

                    cpPosPrensa.JSProperties["cpResultado"] = "Operación realizada con éxito";
                }
            }
            catch (Exception ex)
            {
                cpPosPrensa.JSProperties["cpResultado"] = "Error: " + ex.Message;
            }
        }

        protected void cpSaveDatosOT_Callback(object sender, CallbackEventArgsBase e)
        {
            try
            {
                using (var db = new UnidadDeTrabajo())
                {
                    OrdenTrabajo ot = db.OrdenTrabajo.ObtenerPorId(int.Parse(lblIdOrden.Text));
                    switch (int.Parse(e.Parameter))
                    {
                        case 1:
                            //ot.OperadoresBodegaInventario = cmbOperadorB.Text;
                            //ot.ComentariosBodegaInventario = txtObservacionesB.Text;
                            break;
                        case 2:
                            ot.OperadoresPrensa = cmbOperadorP.Text;
                            ot.ComentariosPrensa = txtObservacionesP.Text;
                            break;
                    }
                    db.OrdenTrabajo.Actualizar(ot);
                    db.Grabar();

                    cpSaveDatosOT.JSProperties["cpResultado"] = "Operación realizada con éxito";
                }
            }
            catch (Exception ex)
            {
                cpSaveDatosOT.JSProperties["cpResultado"] = "Error: " + ex.Message;
            }
        }

        protected void cpOpenReport_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            Session["ItemClickeado"] = "OrdenTrabajo";
            cpOpenReport.JSProperties["cpRedireccion"] = "Reporte.aspx?ot=" + int.Parse(e.Parameter.ToString());
        }
    }
}
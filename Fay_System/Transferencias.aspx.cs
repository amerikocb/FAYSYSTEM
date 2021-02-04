using DevExpress.Web;
using LibreriaDatos.Fay_System;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace Fay_System
{
    public partial class Transferencias : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
                CargarTransferencias_Lista();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 10) == true)
                    {
                        btnAgregarTr.ClientEnabled = false;
                        //btnAjustar.ClientEnabled = false;

                    }
                }
            }
        }

        protected void CargarTransferencias_Lista()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgTransferencias.DataSource = db.TransferenciaStock.ObtenerListaTransferencias();
                //dgUsuarios.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgTransferencias.DataBind();
            }
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }


        protected void btnAgregarMaterial_Click(object sender, EventArgs e)
        {
            int idStock = 0;
            int cantTransferir = 0;
            Stock stkOrigen = new Stock();
            Stock stkDestino = new Stock();
            int idAlmacenOrigen = 0;
            int idAlmacenDestino = 0;
            DateTime fecTransferencia = DateTime.Now;

            //' validaciones:

            mensaje.Text = "";
            if (int.Parse(producto.Value.ToString()) <= 0) { mensaje.Text = "Error: No seleccionó almacen o producto"; return; }


            idAlmacenOrigen = Convert.ToInt32(almacenOrigen.Value);
            idAlmacenDestino = Convert.ToInt32(almacenDestino.Value);

            ObtenerMaterialesPorAlmacen();

            if (idAlmacenOrigen == idAlmacenDestino) { mensaje.Text = "Error: los almacenes no deben ser iguales"; return; }

            if (idAlmacenOrigen == -1) { mensaje.Text = "Error: Debe seleccionar almacen origen"; return; }

            if (idAlmacenDestino == -1) { mensaje.Text = "Error: Debe seleccionar almacen destino"; return; }

            if (!int.TryParse(transferir.Text, out cantTransferir)) { mensaje.Text = "Error: Cantidad inválida"; return; }


            //' controlando la cantidad en origen versus lo que se quiere transferir:

            using (var db = new UnidadDeTrabajo())
            {
                idStock = db.Stock.Stock_leerId(int.Parse(producto.Value.ToString()), idAlmacenOrigen);
                stkOrigen = db.Stock.Stock_leer_x_Id(idStock);
                stkDestino = db.Stock.Stock_leer(stkOrigen.IdMaterial, idAlmacenDestino);
            }

            if (stkOrigen.Stock1 < cantTransferir) {

                mensaje.Text = "Error: Cantidad mayor al stock";
                return; 
            } else
            {
                stkOrigen.Stock1 -= cantTransferir;
                using (var db = new UnidadDeTrabajo())
                {
                    db.Stock.Actualizar(stkOrigen);
                    db.Grabar();
                }
                if (stkDestino != null)
                {
                    stkDestino.Stock1 += cantTransferir;
                    using (var db = new UnidadDeTrabajo())
                    {
                        db.Stock.Actualizar(stkDestino);
                        db.Grabar();
                    }
                }
                else
                {
                    stkDestino = new Stock
                    {
                        IdMaterial = stkOrigen.IdMaterial,
                        IdAlmacen = idAlmacenDestino,
                        Stock1 = cantTransferir
                    };

                    using (var db = new UnidadDeTrabajo())
                    {
                        db.Stock.Insertar(stkDestino);
                        db.Grabar();
                    }
                }
            }

            //' agregando cabecera de transferencia:

            if (nroTransferencia.Text == "") {
                //    ' es la 1ra vez q agrega un item
                TransferenciaStock cabecera = new TransferenciaStock
                {
                    IdAlmacenOrigen = idAlmacenOrigen,
                    IdAlmacenDestino = idAlmacenDestino,
                    Fecha = fecTransferencia,
                    IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                    FechaCreacion = DateTime.Now,
                    Motivo = txtMotivo.Text
                };

                using (var db = new UnidadDeTrabajo())
                {
                    db.TransferenciaStock.Insertar(cabecera);
                    db.Grabar();
                }

                nroTransferencia.Text = cabecera.Id.ToString();
                almacenOrigen.Enabled = false;
                almacenDestino.Enabled = false;
                fecha.Enabled = false;
                txtMotivo.Enabled = false;

                CargarTransferencias_Lista();
            }

            //' agregando detalle de transferencia:

            TransferenciaStockDetalle detalle = new TransferenciaStockDetalle
            {
                IdTransferenciaStock = Convert.ToInt32(nroTransferencia.Text),
                IdMaterial = stkOrigen.IdMaterial,
                Cantidad = cantTransferir,
                FechaCreacion = DateTime.Now
            };

            using (var db = new UnidadDeTrabajo())
            {
                db.TransferenciaStockDetalle.Insertar(detalle);
                db.Grabar();
            }


            transferir.Text = "";
            StockDisponible.Text = "";
            ObtenerMaterialesPorAlmacen();
            producto.Value = null;
            //' actualizando lista de productos agregados
            MaterialesTransferidos_actualizar();
        }

        private void MaterialesTransferidos_actualizar()
        {
            if(nroTransferencia.Text != "")
            {
                using (var db = new UnidadDeTrabajo())
                {
                    productosTransferidos.DataSource = db.TransferenciaStockDetalle.ObtenerListaTransferenciaDetalle_x_IdTransf(int.Parse(nroTransferencia.Text));
                    productosTransferidos.DataBind();
                }
            }
            else
            {
                productosTransferidos.DataSource = null;
                productosTransferidos.DataBind();
            }
        }

        private void ObtenerMaterialesPorAlmacen()
        {
            using (var db = new UnidadDeTrabajo())
            {
                producto.DataSource = db.Material.Obtener_DTOMaterial_x_idAlmacen(Convert.ToInt32(almacenOrigen.Value));
                producto.ValueField = "IdMaterial";
                producto.TextField = "Descripcion";
                producto.DataBind();
            }
        }

        protected void btnAgregarTr_Click(object sender, EventArgs e)
        {
            mensaje.Text = "";
            using (var db = new UnidadDeTrabajo())
            {
                almacenOrigen.DataSource = db.Almacen.ObtenerAlmacenes();
                almacenOrigen.ValueField = "Id";
                almacenOrigen.TextField = "Descripcion";
                almacenOrigen.DataBind();

                almacenDestino.DataSource = db.Almacen.ObtenerAlmacenes();
                almacenDestino.ValueField = "Id";
                almacenDestino.TextField = "Descripcion";
                almacenDestino.DataBind();
            }

            nroTransferencia.Text = "";

            fecha.Value = DateTime.Today;
            fecha.Enabled = true;

            almacenOrigen.Enabled = true;
            almacenDestino.Enabled = true;
            almacenOrigen.Value = null;
            almacenDestino.Value = null;
            producto.Enabled = true;
            btnAgregarMaterial.ClientVisible = true;
            txtMotivo.Text = "";
            txtMotivo.Enabled = true;
            transferir.Value = null;
            transferir.Enabled = true;

            transferir.Text = "";

            MaterialesTransferidos_actualizar();
            ASPxTransferencias.ShowOnPageLoad = true;
        }

        protected void almacenOrigen_SelectedIndexChanged(object sender, EventArgs e)
        {
            ObtenerMaterialesPorAlmacen();
        }

        protected void dgTransferencias_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            switch (e.ButtonID)
            {
                case "Detail":
                    TransferenciaStock ts = new TransferenciaStock();
                    using (var db = new UnidadDeTrabajo())
                    {
                        ts = db.TransferenciaStock.ObtenerPorId(int.Parse(dgTransferencias.GetRowValues(e.VisibleIndex, "Id").ToString()));

                        almacenOrigen.DataSource = db.Almacen.ObtenerAlmacenes();
                        almacenOrigen.ValueField = "Id";
                        almacenOrigen.TextField = "Descripcion";
                        almacenOrigen.DataBind();

                        almacenDestino.DataSource = db.Almacen.ObtenerAlmacenes();
                        almacenDestino.ValueField = "Id";
                        almacenDestino.TextField = "Descripcion";
                        almacenDestino.DataBind();

                        productosTransferidos.DataSource = db.TransferenciaStockDetalle.ObtenerListaTransferenciaDetalle_x_IdTransf(ts.Id);
                        productosTransferidos.DataBind();
                    }
                    mensaje.Text = "";
                    nroTransferencia.Text = ts.Id.ToString();
                    fecha.Value = ts.FechaCreacion;
                    almacenOrigen.Value = ts.IdAlmacenOrigen;
                    almacenOrigen.Enabled = false;
                    almacenDestino.Value = ts.IdAlmacenDestino;
                    almacenDestino.Enabled = false;
                    txtMotivo.Text = ts.Motivo;
                    txtMotivo.Enabled = false;
                    producto.Value = null;
                    producto.Enabled = false;
                    transferir.Value = null;
                    transferir.Enabled = false;
                    btnAgregarMaterial.ClientVisible = false;
                    ASPxTransferencias.ShowOnPageLoad = true;
                    break;
            }
        }
    }
}
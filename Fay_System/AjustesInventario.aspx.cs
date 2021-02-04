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
    public partial class AjustesInventario : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack || Page.IsPostBack)
                CargarAjustesInventario_Lista();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 10) == true)
                    {
                        btnAgregarAjuste.ClientEnabled = false;
                        btnAjustar.ClientEnabled = false;

                    }
                }
            }
        }

        protected void CargarAjustesInventario_Lista()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgAjustesInventario.DataSource = db.AjusteInventario.ObtenerListaAjustesInventario();
                //dgUsuarios.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgAjustesInventario.DataBind();
            }
        }

        protected void dgUsuarios_CustomButtonCallback(object sender, DevExpress.Web.ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            UnidadDeTrabajo wu = new UnidadDeTrabajo();
            switch (e.ButtonID)
            {
                case "Editar":
                    Usuario user = wu.Usuario.ObtenerPorId(int.Parse(dgAjustesInventario.GetRowValues(e.VisibleIndex, "Id").ToString()));
                    break;

            }
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }


        protected void cmbMaterial_Callback(object sender, CallbackEventArgsBase e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                cmbMaterial.DataSource = db.Material.Obtener_DTOMaterial_x_idAlmacen(int.Parse(e.Parameter));
                cmbMaterial.DataBind();
            }
        }

        protected void ProductosAjustados_actualizar()
        {
            if (txtNumeroAjuste.Text != "")
            {
                using (var bd = new UnidadDeTrabajo())
                {
                    dgMaterialesAjustados.DataSource = bd.AjusteInventarioDetalle.AjusteInventarioDetalle_listarDTO(Convert.ToInt32(txtNumeroAjuste.Text));
                    dgMaterialesAjustados.DataBind();
                }
            }
            else
            {
                dgMaterialesAjustados.DataSource = null;
                dgMaterialesAjustados.DataBind();
            }

        }

        protected void dgAjustesInventario_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            //AjusteInventario AjusteInv = new AjusteInventario();
            //Dim metodos As New FreSalud_metodos()
            switch (e.ButtonID)
            {
                case "btnEditar":
                    using (var bd = new UnidadDeTrabajo())
                    {
                        var AjusteInv = bd.AjusteInventario.ajusteInventario_leer(int.Parse(dgAjustesInventario.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        if (AjusteInv != null)
                        {
                            cmbAlmacen.Value = AjusteInv.idAlmacen;
                            txtNumeroAjuste.Value = AjusteInv.id;
                            deFecha.Value = AjusteInv.Fecha;
                            cmbEstado.Value = AjusteInv.IdEstado;
                            btnAjustar.ClientEnabled = false;
                            dgMaterialesAjustados.DataSource = bd.AjusteInventarioDetalle.AjusteInventarioDetalle_listarDTO(Convert.ToInt32(txtNumeroAjuste.Text));
                            dgMaterialesAjustados.DataBind();
                            lblErrores.Text = "";
                            pcAjusteInventario.ShowOnPageLoad = true;
                                cmbMaterial.DataSource = bd.Material.Obtener_DTOMaterial_x_idAlmacen(AjusteInv.idAlmacen);
                            cmbMaterial.DataBind();
                        }
                    }
                    break;
            }
        }

        protected void btnAjustar_Click(object sender, EventArgs e)
        {
            try
            {
                using (var bd = new UnidadDeTrabajo())
                {
                    Stock stock = bd.Stock.Stock_leer(int.Parse(cmbMaterial.Value.ToString()), int.Parse(cmbAlmacen.Value.ToString()));
                    if (stock.Stock1 + int.Parse(txtCantAjustar.Text) < 0) { lblErrores.Text = "Error: El resultado de ajustar no puede dar stock negativo"; }
                    else
                    {
                        //stock.Stock1 += int.Parse(txtCantAjustar.Text);
                        if (txtNumeroAjuste.Text == "")
                        {
                            AjusteInventario ai = new AjusteInventario
                            {
                                idAlmacen = int.Parse(cmbAlmacen.Value.ToString()),
                                idUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                                Fecha = DateTime.Now,
                                FechaAprobacion = DateTime.Now,
                                Motivo = txtMotivo.Text,
                                IdUsuarioAprobacion = 0,
                                IdEstado = 1
                            };

                            bd.AjusteInventario.Insertar(ai);
                            bd.Grabar();

                            txtNumeroAjuste.Text = ai.id.ToString();
                            cmbAlmacen.ReadOnly = true;
                            txtMotivo.Text = ai.Motivo.ToString();
                            txtMotivo.ClientEnabled = false;
                            CargarAjustesInventario_Lista();
                        }
                        AjusteInventarioDetalle aid = new AjusteInventarioDetalle();
                        aid.idAjusteInventario = int.Parse(txtNumeroAjuste.Text);
                        aid.IdMaterial = int.Parse(cmbMaterial.Value.ToString());
                        aid.Cantidad = double.Parse(txtCantAjustar.Text);

                        bd.AjusteInventarioDetalle.Insertar(aid);
                        bd.Grabar();
                        txtCantAjustar.Text = null;
                        //txtCantAjustar.Text = "";
                        ProductosAjustados_actualizar();
                    }
                }
            }
            catch(Exception ex)
            {
                lblErrores.Text = "Error: " + ex.Message;
            }
        }

        protected void btnAgregarAjuste_Click(object sender, EventArgs e)
        {
            deFecha.Value = DateTime.Now;
            cmbEstado.Value = 1;
            txtMotivo.Text = "";
            cmbAlmacen.Value = null;
            cmbMaterial.Value = null;
            txtCantAjustar.Text = "";
            btnAjustar.ClientEnabled = true;
            txtNumeroAjuste.Text = "";
            ProductosAjustados_actualizar();
            lblErrores.Text = "";
            cmbAlmacen.ReadOnly = false;
            pcAjusteInventario.ShowOnPageLoad = true;
        }
    }
}
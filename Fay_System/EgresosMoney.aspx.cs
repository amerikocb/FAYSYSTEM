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
    public partial class EgresosMoney : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!Page.IsPostBack)
            {
                CargarEgresos_Lista();
                using (var db = new UnidadDeTrabajo())
                {
                    cbEmpleado.DataSource = db.Empleado.ObtenerListaEmpleados();
                    cbEmpleado.ValueField = "Id";
                    cbEmpleado.TextField = "NombreCompleto";
                    cbEmpleado.DataBind();
                }
            }

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

        protected void CargarEgresos_Lista()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgEgresos.DataSource = db.Egresos.ObtenerListaEgresos();
                //dgUsuarios.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgEgresos.DataBind();
            }
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }


        protected void btnAgregarTr_Click(object sender, EventArgs e)
        {
            fecha.Value = DateTime.Today;
            fecha.Enabled = true;

            txtMotivo.Text = "";
            txtMotivo.Enabled = true;
            seMonto.Value = null;
            seMonto.Enabled = true;
            cbEmpleado.Value = null;
            cbEmpleado.Enabled = true;

            txtUser.Text = Session["UserActive"].ToString();

            ASPxTransferencias.ShowOnPageLoad = true;
        }

        protected void dgEgresos_CustomButtonCallback(object sender, ASPxGridViewCustomButtonCallbackEventArgs e)
        {
            switch (e.ButtonID)
            {
                case "Detail":
                    Egresos eg = new Egresos();
                    using (var db = new UnidadDeTrabajo())
                    {
                        eg = db.Egresos.ObtenerPorId(int.Parse(dgEgresos.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        IdEgreso.Value = eg.IdEgreso;
                        fecha.Value = eg.FechaCreacion;
                        cbEmpleado.Value = eg.IdEmpleado;
                        txtUser.Text = db.Usuario.ObtenerPorId(eg.IdUsuario).Nombre;
                        txtMotivo.Text = eg.Motivo;
                        seMonto.Value = eg.Monto;

                    }
                    txtMotivo.Enabled = false;
                    seMonto.Enabled = false;
                    cbEmpleado.Enabled = false;
                    fecha.Enabled = false;
                    ASPxTransferencias.ShowOnPageLoad = true;
                    break;
                case "Delete":
                    using (var db = new UnidadDeTrabajo())
                    {
                        Egresos egr = db.Egresos.ObtenerPorId(int.Parse(dgEgresos.GetRowValues(e.VisibleIndex, "Id").ToString()));
                        egr.IdEstado = 73;
                        egr.IdUsuarioEliminacion = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1;
                        egr.FechaEliminacion = DateTime.Now;

                        db.Egresos.Actualizar(egr);
                        db.Grabar();

                    }
                    CargarEgresos_Lista();
                    break;
            }
        }

        protected void btnSaveEgreso_Click(object sender, EventArgs e)
        {
            Egresos eg = new Egresos
            {
                IdEmpleado = int.Parse(cbEmpleado.Value.ToString()),
                IdUsuario = Session["IdUserActive"] != null ? int.Parse(Session["IdUserActive"].ToString()) : 1,
                FechaCreacion = DateTime.Now,
                IdEstado = 72,
                Monto = decimal.Parse(seMonto.Value.ToString()),
                Motivo = txtMotivo.Text,
            };
            using (var db = new UnidadDeTrabajo())
            {
                db.Egresos.Insertar(eg);
                db.Grabar();
            }

            CargarEgresos_Lista();
            ASPxTransferencias.ShowOnPageLoad = false;
        }
    }
}
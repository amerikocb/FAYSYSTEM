using LibreriaDatos.DTO;
using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class Empresas : System.Web.UI.Page
    {
        int idEmpresaInsertada = 0, IdPersonaInsertada = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarEmpresas_Listado();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 6) == true)
                    {
                        btnAgregarEmpresas.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;

                    }
                }
            }
        }

        protected void CargarEmpresas_Listado()
        {
            using(var db = new UnidadDeTrabajo())
            {
                dgEmpresas.DataSource = db.Empresa.ObtenerListaEmpresas();
                dgEmpresas.Settings.ShowStatusBar = DevExpress.Web.GridViewStatusBarMode.Hidden;
                dgEmpresas.DataBind();
            }
        }

        protected void btnAgregarEmpresas_Click(object sender, EventArgs e)
        {
            pcEmpresas.ShowOnPageLoad = true;
        }

        protected void cpEditorEmpresas_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = bd.Estado.ObtenerEstado_x_Tipo(4);
                cmbEstado.DataBind();
                Empresa empresa_a_editar = new Empresa();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter));
                }
                else
                {
                    txtRUC.Text = "";
                    txtRazonSocial.Text = "";
                    txtTelefono.Text = "";
                    txtDireccion.Text = "";
                    txtEmail.Text = "";
                    txtId.Text = "";
                    txtPagWeb.Text = "";
                    cmbProveedor.Value = null;
                    cmbEstado.Value = 8;
                }
            }
        }

        private void actualizar_datos_de_edicion_y_de_lectura(int IdEmpresa)
        {
            txtId.ReadOnly = false;
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                DTOEmpresa empresaDetalle = bd.Empresa.Obtener_DTOEmpresa_x_idEmpresa(IdEmpresa);
                if (empresaDetalle != null)
                {
                    cmbEstado.DataSource = bd.Estado.Obtener(es => es.IdTipoEstado == 4);
                    cmbEstado.DataBind();

                    txtId.Value = empresaDetalle.Id;
                    txtRUC.Text = empresaDetalle.RUC;
                    txtRazonSocial.Text = empresaDetalle.RazonSocial;
                    txtTelefono.Text = empresaDetalle.Telefono;
                    txtDireccion.Text = empresaDetalle.Direccion;
                    txtEmail.Text = empresaDetalle.Email;
                    txtPagWeb.Text = empresaDetalle.PaginaWeb;
                    cmbEstado.Value = empresaDetalle.IdEstado;
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            Empresa empresa = new Empresa();
            Persona persona = new Persona();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        AdministrarEmpresa(0, 1);
                        AdministrarPersona(bd.Empresa.ObtenerPorId(int.Parse(txtId.Text)).IdPersona, 1);
                    }
                    //MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al actualizar: " + ex.Message);
                }
            }
            else //Agregar
            {
                try
                {
                    AdministrarEmpresa(AdministrarPersona(0, 2), 2);
                    //MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcEmpresas.ShowOnPageLoad = false;
            CargarEmpresas_Listado();
        }
        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
        protected void dgEmpresas_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }
        protected int AdministrarPersona(int IdPersona, int Operacion)
        {
            try
            {
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Persona personaActualizar = bd.Persona.ObtenerPorId(IdPersona);

                            personaActualizar.RazonSocial = txtRazonSocial.Text;
                            personaActualizar.Ruc = txtRUC.Text;
                            personaActualizar.Telefono = txtTelefono.Text;
                            personaActualizar.Direccion = txtDireccion.Text;
                            personaActualizar.Email = txtEmail.Text;
                            personaActualizar.PaginaWeb = txtPagWeb.Text;
                            bd.Persona.Actualizar(personaActualizar);
                            bd.Grabar();
                            IdPersonaInsertada = 0;
                            break;
                        case 2:
                            if (bd.Persona.ObtenerPersona_x_RUC(txtRUC.Text) == false)
                            {
                                var personaNueva = new Persona
                                {
                                    FechaCreacion = DateTime.Today,
                                    RazonSocial = txtRazonSocial.Text,
                                    Ruc = txtRUC.Text,
                                    Telefono = txtTelefono.Text,
                                    Direccion = txtDireccion.Text,
                                    Email = txtEmail.Text,
                                    PaginaWeb = txtPagWeb.Text,
                                    TipoPersona = "JURÍDICA"
                                };
                                bd.Persona.Insertar(personaNueva);
                                bd.Grabar();
                                IdPersonaInsertada = personaNueva.Id;
                            }
                            else
                                IdPersonaInsertada = 0;
                            break;
                    }
                }
                //MostrarMensajes("Operación realizada con éxito");
            }
            catch (Exception ex)
            {
                IdPersonaInsertada = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en adminsitración personas: " + ex.Message);
            }
            return IdPersonaInsertada;
        }
        /// <summary>
        /// Inserta o actualiza empresas de acuerdo al parámetro Operación
        /// </summary>
        /// <param name="idpersona">0 = No se Inserta, >0 = Si se inserta persona</param>
        /// <param name="Operacion">1=Editar, 2=Insertar</param>
        /// <returns></returns>
        protected int AdministrarEmpresa(int idpersona, int Operacion)
        {
            try
            {
                bool esprov = false;
                if (int.Parse(cmbProveedor.Value.ToString()) == 1) esprov = true;
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Empresa empresaActualizar = bd.Empresa.ObtenerPorId(int.Parse(txtId.Text));
                            empresaActualizar.IdEstado = int.Parse(cmbEstado.Value.ToString());
                            empresaActualizar.Proveedor = esprov;
                            empresaActualizar.Contacto = txtContact.Text;
                            bd.Empresa.Actualizar(empresaActualizar);
                            bd.Grabar();
                            idEmpresaInsertada = 0;
                            MostrarMensajes("Operación realizada con éxito");
                            break;
                        case 2:
                            if(idpersona > 0)
                            {
                                var empresaInsertar = new Empresa
                                {
                                    IdPersona = idpersona,
                                    FechaCreacion = DateTime.Today,
                                    IdEstado = 8,
                                    Proveedor = esprov,
                                    Contacto = txtContact.Text

                                };
                                bd.Empresa.Insertar(empresaInsertar);
                                bd.Grabar();
                                idEmpresaInsertada = empresaInsertar.Id;
                                MostrarMensajes("Operación realizada con éxito");
                            }
                            else
                            {
                                MostrarMensajes("Operación denegada: El RUC ya se encuentra registrado!!");
                            }
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                idEmpresaInsertada = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en administración empresas: " + ex.Message);
            }
            return idEmpresaInsertada;
        }
    }
}
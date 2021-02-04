using LibreriaDatos.DTO;
using LibreriaDatos.Fay_System;
using System;

namespace Fay_System
{
    public partial class Empleados : System.Web.UI.Page
    {
        int idEmpleadoInsertado = 0, IdPersonaInsertada = 0;
        protected void Page_Load(object sender, EventArgs e)
        {
            CargarEmpleados_Listado();

            using (var ut = new UnidadDeTrabajo())
            {
                if (Session["IdUserActive"] != null)
                {
                    if (ut.ComprobarSoloLectura(int.Parse(Session["IdUserActive"].ToString()), 5) == true)
                    {
                        btnAgregarEmpleados.ClientEnabled = false;
                        btnAceptar.ClientEnabled = false;

                    }
                }
            }
        }

        private void CargarEmpleados_Listado()
        {
            using (var db = new UnidadDeTrabajo())
            {
                dgEmpleados.DataSource = db.Empleado.ObtenerListaEmpleados();
                dgEmpleados.DataBind();
            }
        }

        protected void btnAgregarEmpleados_Click(object sender, EventArgs e)
        {
            pcEmpleados.ShowOnPageLoad = true;
            using (var db = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = db.Estado.Obtener(te => te.IdTipoEstado == 3);
                cmbEstado.DataBind();

                cmbProfesion.DataSource = db.TipoProfesion.Obtener();
                cmbProfesion.DataBind();

                cmbCargo.DataSource = db.Cargo.Obtener();
                cmbCargo.DataBind();


            }

        }

        protected void cpEditorEmpleados_Callback(object sender, DevExpress.Web.CallbackEventArgsBase e)
        {
            using (var db = new UnidadDeTrabajo())
            {
                cmbEstado.DataSource = db.Estado.Obtener(te => te.IdTipoEstado == 3);
                cmbEstado.DataBind();

                cmbProfesion.DataSource = db.TipoProfesion.Obtener();
                cmbProfesion.DataBind();

                cmbCargo.DataSource = db.Cargo.Obtener();
                cmbCargo.DataBind();
            }
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                Empleado empleado_a_editar = new Empleado();
                if (campoO.Text == "1")
                {
                    actualizar_datos_de_edicion_y_de_lectura(int.Parse(e.Parameter));
                }
                else
                {

                    txtDni.Text = "";
                    txtNombre.Text = "";
                    txtApPaterno.Text = "";
                    txtApMaterno.Text = "";
                    txtTelefono.Text = "";
                    txtDireccion.Text = "";
                    txtEmail.Text = "";
                    txtId.Text = "";
                    txtRuc.Text = "";
                    cmbCargo.Value = "";
                    cmbProfesion.Value = "";
                    //cmbProfesion.ClientEnabled = false;
                    cmbSexo.Value = "";
                    cmbEstado.Value = 6;
                    deFechaN.Value = null;

                }
            }
        }
        private void actualizar_datos_de_edicion_y_de_lectura(int IdEmpleado)
        {
            txtId.ReadOnly = false;
            using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
            {
                DTOEmpleado empleadoDetalle = bd.Empleado.Obtener_DTOEmpleado_x_idEmpleado(IdEmpleado);
                if (empleadoDetalle != null)
                {
                    cmbEstado.DataSource = bd.Estado.Obtener(es => es.IdTipoEstado == 3);
                    cmbEstado.DataBind();

                    txtId.Value = empleadoDetalle.Id;
                    txtRuc.Text = empleadoDetalle.RUC;
                    txtNombre.Text = empleadoDetalle.Nombres;
                    txtApPaterno.Text = empleadoDetalle.ApPaterno;
                    txtApMaterno.Text = empleadoDetalle.ApMaterno;
                    txtTelefono.Text = empleadoDetalle.Telefono;
                    txtDireccion.Text = empleadoDetalle.Direccion;
                    txtEmail.Text = empleadoDetalle.Email;
                    cmbCargo.Value = empleadoDetalle.IdCargo;
                    cmbProfesion.Value = empleadoDetalle.IdProfesion;
                    cmbEstado.Value = empleadoDetalle.IdEstado;
                    cmbSexo.Value = empleadoDetalle.Sexo;
                    txtDni.Value = empleadoDetalle.DNI;
                }
                else
                {
                    //mensaje.Text = "Activo no encontrado";
                }
            }
        }

        protected void btnAceptar_Click(object sender, EventArgs e)
        {
            //Empleado empleado = new Empleado();
            //Persona persona = new Persona();
            if (campoO.Text == "1")//Editar
            {
                try
                {
                    using (var bd = new UnidadDeTrabajo())
                    {
                        AdministrarEmpleado(0, 1);
                        AdministrarPersona(bd.Empleado.ObtenerPorId(int.Parse(txtId.Text)).IdPersona, 1);
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
                    AdministrarEmpleado(AdministrarPersona(0, 2), 2);
                    //MostrarMensajes("Operación realizada con éxito");
                }
                catch (Exception ex)
                {
                    MostrarMensajes("Ha ocurrido un error inesperado al agregar: " + ex.Message);

                }

            }
            pcEmpleados.ShowOnPageLoad = false;
            CargarEmpleados_Listado();

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
                            personaActualizar.Nombres = txtNombre.Text;
                            personaActualizar.ApellidoPaterno = txtApPaterno.Text;
                            personaActualizar.ApellidoMaterno = txtApMaterno.Text;
                            personaActualizar.Ruc = txtRuc.Text;
                            personaActualizar.Telefono = txtTelefono.Text;
                            personaActualizar.Direccion = txtDireccion.Text;
                            personaActualizar.Email = txtEmail.Text;
                            personaActualizar.DNI = txtDni.Text;
                            personaActualizar.Sexo = cmbSexo.Text;
                            personaActualizar.FechaNacimiento = DateTime.Parse(deFechaN.Text);
                            bd.Persona.Actualizar(personaActualizar);
                            bd.Grabar();
                            IdPersonaInsertada = 0;
                            break;
                        case 2:
                            if (bd.Persona.ObtenerPersonaEmpleado_x_DNI(txtDni.Text) == false)
                            {
                                var personaNueva = new Persona
                                {
                                    FechaCreacion = DateTime.Today,
                                    FechaNacimiento = DateTime.Parse(deFechaN.Text),
                                    Nombres = txtNombre.Text,
                                    ApellidoPaterno = txtApPaterno.Text,
                                    ApellidoMaterno = txtApMaterno.Text,
                                    Ruc = txtRuc.Text,
                                    Telefono = txtTelefono.Text,
                                    Direccion = txtDireccion.Text,
                                    Email = txtEmail.Text,
                                    DNI = txtDni.Text,
                                    Sexo = cmbSexo.Text,
                                    RazonSocial = txtApPaterno.Text + "" + txtApMaterno.Text + "" + txtNombre.Text,
                                    TipoPersona = "NATURAL"
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
        protected int AdministrarEmpleado(int idpersona, int Operacion)
        {
            try
            {
                using (UnidadDeTrabajo bd = new UnidadDeTrabajo())
                {
                    switch (Operacion)
                    {
                        case 1:
                            Empleado empleadoActualizar = bd.Empleado.ObtenerPorId(int.Parse(txtId.Text));
                            empleadoActualizar.IdEstado = int.Parse(cmbEstado.Value.ToString());
                            empleadoActualizar.IdCargo = int.Parse(cmbCargo.Value.ToString());
                            empleadoActualizar.IdTipoProfesion = int.Parse(cmbProfesion.Value.ToString());
                            bd.Empleado.Actualizar(empleadoActualizar);
                            bd.Grabar();
                            idEmpleadoInsertado = 0;
                            MostrarMensajes("Operación realizada con éxito");
                            break;
                        case 2:
                            if (idpersona > 0)
                            {
                                var empleadoInsertar = new Empleado
                                {
                                    IdPersona = idpersona,
                                    IdEstado = 6,
                                    IdCargo = int.Parse(cmbCargo.Value.ToString()),
                                    IdTipoProfesion = int.Parse(cmbProfesion.Value.ToString())

                                };
                                bd.Empleado.Insertar(empleadoInsertar);
                                bd.Grabar();
                                idEmpleadoInsertado = empleadoInsertar.Id;
                            }
                            else
                                MostrarMensajes("Operación denegada: ya existe un empleado registrado con el número de dni ingresado!!");
                            break;
                    }
                }
            }
            catch (Exception ex)
            {
                idEmpleadoInsertado = 0;
                MostrarMensajes("Ha ocurrido un error inesperado en administración empresas: " + ex.Message);
            }
            return idEmpleadoInsertado;
        }

        protected void dgEmpleados_CommandButtonInitialize(object sender, DevExpress.Web.ASPxGridViewCommandButtonEventArgs e)
        {
            if (e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Update || e.ButtonType == DevExpress.Web.ColumnCommandButtonType.Cancel)
                e.Visible = false;
        }

        protected void MostrarMensajes(string mensaje)
        {
            //ClientScript.RegisterStartupScript(this.GetType(), "myScript", "<script>javascript:LanzarMensaje('" + mensaje + "');</script>");
            lblMessage.Text = mensaje;
            pcShowResults.ShowOnPageLoad = true;
        }
    }
}
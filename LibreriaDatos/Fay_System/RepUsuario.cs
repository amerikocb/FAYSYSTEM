using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace LibreriaDatos.Fay_System
{
    public class RepUsuario : Repositorio<Usuario>
    {
        public RepUsuario(FayceEntities contexto) : base(contexto)
        {
        }

        public List<DTOUsuario> ObtenerListaUsuarios()
        {
            return (from u in _contexto.Usuario
                    join em in _contexto.Empleado on u.IdEmpleado equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    join tu in _contexto.TipoUsuario on u.IdTipoUsuario equals tu.Id
                    join e in _contexto.Estado on u.IdEstado equals e.Id
                    select new DTOUsuario
                    {
                        Id = u.id,
                        Nombre = u.Nombre,
                        ApellidoPaterno = p.ApellidoPaterno,
                        ApellidoMaterno = p.ApellidoMaterno,
                        Nombres = p.Nombres,
                        DescripcionTipoU = tu.Descripcion,
                        IdTipoUsuario = tu.Id,
                        IdEstado = e.Id,
                        DescripcionEstado =e.Descripcion
                    }).OrderByDescending(u => u.Id).ToList();
        }

        public Usuario ObtenerUsuarioPorNombreMasContraseña(string nombre, string pass)
        {
            string query = "SELECT * FROM Usuario WHERE Nombre = '" + nombre + "' AND dbo.Desencriptar(Password, 'clave') = '" + pass + "'";
            return _contexto.Usuario.SqlQuery(query).FirstOrDefault();
        }
        public Usuario ObtenerUsuarioPorId(int idUsuario)
        {
            string query = "SELECT * FROM Usuario WHERE Id = " + idUsuario;
            return _contexto.Usuario.SqlQuery(query).FirstOrDefault();
        }
        public void InsertarUsuario(string nombre, string pass, int idEmpleado, int idTipoUsuario, int idEstado)
        {
            string query = "INSERT INTO Usuario(Nombre, Password, IdEmpleado, IdTipoUsuario, IdEstado) VALUES('" + nombre + "', dbo.Encriptar('" + pass + "', 'clave')," + idEmpleado + ", " + idTipoUsuario + ", " + idEstado + ")";
            _contexto.Database.ExecuteSqlCommand(query);
        }
        public void ActualizarUsuario(int idUsuario, string nombre, string pass, int idEmpleado, int idTipoUsuario, int idEstado)
        {
            string query = "UPDATE Usuario SET Nombre = '" + nombre + "', Password = dbo.Encriptar('" + pass + "', 'clave'), IdEmpleado = " + idEmpleado + ", IdTipoUsuario = " + idTipoUsuario + ", IdEstado = " + idEstado + " WHERE Id = " + idUsuario;
            _contexto.Database.ExecuteSqlCommand(query);
        }

        public bool ObtenerUsuario_x_user(string user)
        {
            var res = _contexto.Usuario.Where(u => u.Nombre == user).FirstOrDefault();
            if (res != null)
                return true;
            else
                return false;
        }

    }
}

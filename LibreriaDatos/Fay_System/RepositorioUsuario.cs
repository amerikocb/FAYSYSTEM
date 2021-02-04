using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioUsuario
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioUsuario: Repositorio<Usuario>, IRepositorioUsuario
    {
        public RepositorioUsuario(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

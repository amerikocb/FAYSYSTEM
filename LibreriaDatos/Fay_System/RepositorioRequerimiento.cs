using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioRequerimiento
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioRequerimiento: Repositorio<Requerimiento>, IRepositorioRequerimiento
    {
        public RepositorioRequerimiento(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

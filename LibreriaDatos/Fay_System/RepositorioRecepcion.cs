using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioRecepcion
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioRecepcion: Repositorio<Recepcion>, IRepositorioRecepcion
    {
        public RepositorioRecepcion(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

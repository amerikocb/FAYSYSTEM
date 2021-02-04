using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioRecepcionDetalle
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioRecepcionDetalle: Repositorio<RecepcionDetalle>, IRepositorioRecepcionDetalle
    {
        public RepositorioRecepcionDetalle(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

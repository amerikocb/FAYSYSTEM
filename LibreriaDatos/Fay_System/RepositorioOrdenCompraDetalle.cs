using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioOrdenCompraDetalle
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioOrdenCompraDetalle: Repositorio<OrdenCompraDetalle>, IRepositorioOrdenCompraDetalle
    {
        public RepositorioOrdenCompraDetalle(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

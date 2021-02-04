using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioOrdenCompra
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioOrdenCompra: Repositorio<OrdenCompra>, IRepositorioOrdenCompra
    {
        public RepositorioOrdenCompra(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

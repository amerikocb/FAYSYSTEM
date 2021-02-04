using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioTipoDocumento
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioTipoDocumento: Repositorio<TipoDocumento>, IRepositorioTipoDocumento
    {
        public RepositorioTipoDocumento(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

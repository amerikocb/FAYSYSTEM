

namespace LibreriaDatos.Fay_System
{
    interface IRepositorioRequerimientoDetalle
    {
        //Boolean ObtenerPorParametros(string codigoActividad, int varIdOrganizacion, out int idActividad);
    }
    public class RepositorioRequerimientoDetalle: Repositorio<CotizacionDetalle>, IRepositorioRequerimientoDetalle
    {
        public RepositorioRequerimientoDetalle(FayceEntities contexto) : base(contexto)
        {
        }
    }
}

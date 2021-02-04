using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepRecepcion:Repositorio<Recepcion>
    {
        public RepRecepcion(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTORecepciones> ObtenerListaRecepciones()
        {
            return (from r in _contexto.Recepcion
                    join u in _contexto.Usuario on r.IdUsuario equals u.id
                    join e in _contexto.Empresa on r.IdEmpresa equals e.Id
                    join p in _contexto.Persona on e.IdPersona equals p.Id
                    select new DTORecepciones
                    {
                        Id = r.Id,
                        IdOrdenCompra = r.IdOrdenCompra,
                        Fecha = r.FechaCreacion,
                        Usuario = u.Nombre,
                        IdProveedor = r.IdEmpresa,
                        RazonSocial = p.RazonSocial,
                        Documento= "",
                        Numero = r.NumeroComprobante,
                        Serie = r.SerieComprobante

                    }).OrderByDescending(o => o.Fecha).ToList();
        }
        public DTORecepciones ObtenerRecepcionPorId(int IdRecepcion)
        {
            return (from r in _contexto.Recepcion 
                    join u in _contexto.Usuario on r.IdUsuario equals u.id
                    join e in _contexto.Estado on r.IdEstado equals e.Id
                    join em in _contexto.Empresa on r.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    select new DTORecepciones
                    {
                        Id = r.Id,
                        IdOrdenCompra = r.IdOrdenCompra,
                        Fecha = r.FechaCreacion,
                        Usuario = u.Nombre,
                        IdProveedor = r.IdEmpresa,
                        RazonSocial = p.RazonSocial,
                        Documento = "",
                        Numero = r.NumeroComprobante,
                        Serie = r.SerieComprobante
                    }).OrderByDescending(o => o.Fecha).FirstOrDefault();
        }
    }
}

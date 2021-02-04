using LibreriaDatos.DTO;
using System;
using System.Collections.Generic;
using System.Data.Entity.SqlServer;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    public class RepOrdenCompra:Repositorio<OrdenCompra>
    {
        public RepOrdenCompra(FayceEntities contexto) : base(contexto)
        {
        }
        public List<DTOOrdenesCompra> ObtenerListaOrdenesCompra()
        {
            return (from o in _contexto.OrdenCompra
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa  equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    select new DTOOrdenesCompra
                    {
                        Id = o.Id,
                        Fecha = o.FechaCreacion,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion,
                        RazonSocial = p.RazonSocial,
                        DocumentoReferencia= o.DocumentoReferencia,
                        NRequerimiento = o.IdRequerimiento
                    }).OrderByDescending(o => o.Fecha).ToList();
        }
        public List<DTOOrdenesCompra> ObtenerListaOrdenesCompraPendientesDeRecepcion()
        {
            List<int?> estadosOcNO = new List<int?>(new int?[] { 11, 12 });
            return (from o in _contexto.OrdenCompra
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    where o.IdEstado == 10 || o.IdEstado == 21
                    select new DTOOrdenesCompra
                    {
                        Id = o.Id,
                        Fecha = o.Fecha,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion,
                        RazonSocial = p.RazonSocial,
                        DocumentoReferencia = o.DocumentoReferencia,
                        NRequerimiento = o.IdRequerimiento
                    }).OrderByDescending(o => o.Fecha).ToList();
        }
        public DTOOrdenesCompra ObtenerOrdenCompraPorId(int IdOrdenCompra)
        {
            return (from o in _contexto.OrdenCompra
                    join u in _contexto.Usuario on o.IdUsuario equals u.id
                    join e in _contexto.Estado on o.IdEstado equals e.Id
                    join em in _contexto.Empresa on o.IdEmpresa equals em.Id
                    join p in _contexto.Persona on em.IdPersona equals p.Id
                    select new DTOOrdenesCompra
                    {
                        Id = o.Id,
                        Fecha = o.FechaCreacion,
                        Usuario = u.Nombre,
                        Estado = e.Descripcion,
                        RazonSocial = p.RazonSocial,
                        DocumentoReferencia = o.DocumentoReferencia,
                        NRequerimiento = o.IdRequerimiento
                    }).OrderByDescending(o => o.Fecha).FirstOrDefault();
        }
        public void RecepcionarOrdenCompra(int IdOrdenCompra, int IdEstado)
        {
            OrdenCompra oc = _contexto.OrdenCompra.Where(o => o.Id == IdOrdenCompra).FirstOrDefault<OrdenCompra>();
            oc.IdEstado = IdEstado;
            _contexto.SaveChanges();
        }
    }
}
using LibreriaDatos;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Linq.Expressions;
using System.Text;
using System.Threading.Tasks;

namespace LibreriaDatos.Fay_System
{
    /// <summary>
    /// Repositorio Generico para cualquier tabla.  Genera los metodos basicos a base de datos para CRUD
    /// </summary>
    /// <typeparam name="TEntity"></typeparam>
    public class Repositorio<TEntity> where TEntity : class
    {
        internal FayceEntities _contexto;
        internal DbSet<TEntity> dbSet;

        public Repositorio(FayceEntities contexto)
        {
            this._contexto = contexto;
            this.dbSet = this._contexto.Set<TEntity>();
        }

        /// <summary>
        /// Permite leer los registros de la tabla pero con posibilidad de filtrar, ordenar, incluir otras tablas y cant filas
        /// </summary>
        /// <param name="filtrar"></param>
        /// <param name="ordenarPor"></param>
        /// <param name="incluirPropiedades"></param>
        /// <param name="nroFilas">si se ingresa 0 trae todas las filas</param>
        /// <returns></returns>
        public virtual IEnumerable<TEntity> Obtener(
            Expression<Func<TEntity, bool>> filtrar = null,
            Func<IQueryable<TEntity>, IOrderedQueryable<TEntity>> ordenarPor = null,
            string incluirPropiedades = "",
            int nroFilas = 0)
        {
            IQueryable<TEntity> query = dbSet;

            if (filtrar != null)
            {
                query = query.Where(filtrar);
            }

            foreach (var includeProperty in incluirPropiedades.Split
                (new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries))
            {
                query = query.Include(incluirPropiedades);
            }

            if (ordenarPor != null)
            {
                query = ordenarPor(query);
            }

            if (nroFilas > 0)
            {
                query = query.Take(nroFilas);
            }

            return query.ToList();

            //if (ordenarPor != null)
            //{
            //    return ordenarPor(query).ToList();
            //}
            //else
            //{
            //    return query.ToList();
            //}
        }

        public virtual TEntity ObtenerPorId(object id)
        {
            return dbSet.Find(id);
        }

        public virtual void Insertar(TEntity entidad)
        {
            dbSet.Add(entidad);
        }

        public void InsertarRango(IEnumerable<TEntity> entidades)
        {
            dbSet.AddRange(entidades);
        }

        public virtual void EliminarPorId(object id)
        {
            TEntity entidadAEliminar = dbSet.Find(id);
            Eliminar(entidadAEliminar);
        }

        public virtual void Eliminar(TEntity entidadAEliminar)
        {
            if (_contexto.Entry(entidadAEliminar).State == EntityState.Detached)
            {
                dbSet.Attach(entidadAEliminar);
            }
            dbSet.Remove(entidadAEliminar);
        }

        public void EliminarRango(IEnumerable<TEntity> entidades)
        {
            dbSet.RemoveRange(entidades);
        }

        public virtual void Actualizar(TEntity entidadAActualizar)
        {
            dbSet.Attach(entidadAActualizar);
            _contexto.Entry(entidadAActualizar).State = EntityState.Modified;
        }

        public virtual bool Existe(Expression<Func<TEntity, bool>> filtrar)
        {
            IQueryable<TEntity> query = dbSet;
            return filtrar == null? false : query.Any(filtrar);
        }
    }

}

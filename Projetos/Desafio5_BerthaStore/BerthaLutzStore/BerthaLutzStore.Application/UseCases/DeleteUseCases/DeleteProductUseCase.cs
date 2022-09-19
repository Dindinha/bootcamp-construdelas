﻿using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AutoMapper;
using BerthaLutzStore.Application.Models.DeleteProduct;
using BerthaLutzStore.Core.Interfaces;
using BerthaLutzStore.Core.Entities;

namespace BerthaLutzStore.Application.UseCases
{
    public class DeleteProductUseCase : IUseCaseAsync<DeleteProductRequest, IActionResult>
    {
        private readonly IProductRepository _repository;
        private readonly IMapper _mapper;

        public DeleteProductUseCase(IProductRepository repository,
            IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<IActionResult> ExecuteAsync(DeleteProductRequest request)
        {
            if (request == null)
                return new BadRequestResult();

            var product = await _repository.Search(request.IdProduct);

            await _repository.Delete(product);

            return new OkResult();
        }
    }
}

﻿using System;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using AutoMapper;
using BerthaLutzStore.Application.Models.SearchAllUsers;
using BerthaLutzStore.Core.Interfaces;
using BerthaLutzStore.Core.Entities;
using System.Collections.Generic;

namespace BerthaLutzStore.Application.UseCases
{
    public class SearchAllUsersUseCase : IUseCaseAsync<SearchAllUsersRequest, List<IActionResult>>
    {
        private readonly IProductRepository _repository;
        private readonly IMapper _mapper;

        public SearchAllUsersUseCase(IProductRepository repository,
            IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }

        public async Task<List<IActionResult>> ExecuteAsync(SearchAllUsersRequest request)
        {
            var users = await _repository.SearchAll();
            var usersResponse = _mapper.Map<List<IActionResult>>(users);

            return usersResponse;
        }
    }
}

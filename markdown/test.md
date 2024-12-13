# Test

🏠[Home](../README.md)  🔙 [Back](verification.md)

[**🔗Link to File**](../uvm_verification/router_test/router_test.sv)

Setting Cofiguration db with testbench architecture details. 
```sv
uvm_config_db#(router_env_config)::set(this, "*", "router_env_config", m_env_cfg);
```

create and start the virtual sequence and set te address to config_db

1. router_small_test
2. router_med_test
3. router_big_test
4. router_soft_test
5. router_error_test 
   - here transcation class is overriden by error class

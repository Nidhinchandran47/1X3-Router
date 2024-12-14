# Virtual Sequence and Sequencer


🏠[Home](../README.md)  🔙 [Back](verification.md)

[**Virtual Sequence**](../uvm_verification/router_tb/router_virtual_seqs.sv)

[**Virtual Sequencer**](../uvm_verification/router_tb/router_virtual_sequencer.sv)

A Virtual Sequencer is used in the simulus generation process to allow a single sequence to control activity via several agent.

- it is not attached to any driver
- Does not process items itself
- Has reference to multiple sequencers

Contain a handle of Sequence.

---

Virtual sequence invokes sequences only on virtual sequencer

- Can work as stand alone

Contain handles of both local and Virtual sequencers. Virtual sequencer handle is connected to m_sequencer using `$cast`

```sv
assert ($cast(vsqrh, m_sequencer))
```

Each sequencer handle is assigned with corresponding sequence inside virtual sequencer. 
```sv
src_seqrh[i] = vsqrh.src_seqrh[i];
```

Then sequence is created and started accordingly.

```sv
src_seq = small_seq::type_id::create("src_seq");
src_seq.start(src_seqrh[0]);
```

If multiple sequences are needed to drive same time, `fork join` need to use.

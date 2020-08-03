package josephsmendoza.ipc;

import sys.io.Process;
/**
    IPC client for both parent and child processes.
    Keep in mind that STDIO is almost always blocking,  
    so your thread will halt until the other client  
    reads your write or writes to your read.
**/
class ProcessClient extends IOClient {
    /**
        This function sets the I/O for this client
        to the stdio of the given process.

        @param proc the child process, `null` = this process.
        @see https://en.wikipedia.org/wiki/Standard_streams#mw-content-text:~:text=When%20a%20command%20is%20executed%20via,changed%20with%20redirection%20or%20a%20pipeline.
    **/
    public function new(proc:Process) {
        if(proc==null){
            super(Sys.stdin(),Sys.stdout());
        }else{
            super(proc.stdout,proc.stdin);
        }
    }
}
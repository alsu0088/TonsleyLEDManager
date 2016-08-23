class Runner:
    def __init__(self, dims):
        self.width = dims[0]
        self.height = dims[1]

        import pyopencl as cl
        import numpy as np
        from matplotlib import cm

        self.cm = cm
        self.np = np
        self.cl = cl

        platform = cl.get_platforms();
        my_gpu_devices = platform[0].get_devices(cl.device_type.GPU);
        self.ctx = cl.Context([my_gpu_devices[0]])
        self.queue = cl.CommandQueue(self.ctx)
        self.prg = cl.Program(self.ctx, """
        #pragma OPENCL EXTENSION cl_khr_byte_addressable_store : enable
        __kernel void mandelbrot(__global float2 *q,
                         __global ushort *output, ushort const maxiter)
        {
            int gid = get_global_id(0);
            float nreal, real = 0;
            float imag = 0;
            output[gid] = 0;
            for(int curiter = 0; curiter < maxiter; curiter++) {
                nreal = real*real - imag*imag + q[gid].x;
                imag = 2* real*imag + q[gid].y;
                real = nreal;
                if (real*real + imag*imag > 4.0f){
                     output[gid] = curiter;
                     break;
                }
            }
        }
        """).build()
        import time
        self.time = time
        # self.xmin = -.74877
        # self.xmax = -0.74872
        # self.ymin = 0.065053
        # self.ymax = 0.065103
        self.xmin = -np.pi
        self.xmax = np.pi
        self.ymin = -np.pi
        self.ymax = np.pi
        cmap = self.cm.get_cmap('magma', 80)
        self.cols = (cmap.colors*255)[0:, :3].astype(self.np.uint8)


    def mandelbrot_set3(self, xmin, xmax, ymin, ymax, width, height, maxiter):
        r1 = self.np.linspace(xmin, xmax, width, dtype=self.np.float32)
        r2 = self.np.linspace(ymin, ymax, height, dtype=self.np.float32)
        c = r1 + r2[:, None] * .65j
        c = self.np.ravel(c)
        n3 = self.generate(c, maxiter)
        # n3 = n3.reshape((width, height))
        return n3.T
    
    def generate(self, q, maxiter):
        output = self.np.empty(q.shape, dtype=self.np.uint16)
        mf = self.cl.mem_flags
        q_opencl = self.cl.Buffer(self.ctx, mf.READ_ONLY | mf.COPY_HOST_PTR, hostbuf=q)
        output_opencl = self.cl.Buffer(self.ctx, mf.WRITE_ONLY, output.nbytes)
        self.prg.mandelbrot(self.queue, output.shape, None, q_opencl, output_opencl, self.np.uint16(maxiter))
        self.cl.enqueue_copy(self.queue, output, output_opencl).wait()
        return output

    def render(self):

        f = lambda x: self.cols[x]
        return self.np.array(map(f,self.cells)).reshape((self.width, self.height, 3))

    def run(self):
        # start = self.time.time()
        self.cells = self.mandelbrot_set3(self.xmin, self.xmax, self.ymin, self.ymax, width=self.width, height=self.height, maxiter=80)
        # print self.time.time() - start
        out = self.render()
        self.xmin *= .9
        self.ymin *= .99
        self.ymax *= .99
        self.xmax *= .99

        return out
if __name__ == "__main__":
    from demo import show
    show(Runner, fps=30, rows=800, cols=800, scale=1)

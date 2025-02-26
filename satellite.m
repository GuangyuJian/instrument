classdef satellite<handle


    properties

        epoch   %s
        pos     %m/s
        vel     %m/s
        ref

        %----------------------------
        ramp
        vamp
        %----------------------------
        rmspos
        rmsvel

    end


    methods
        function [self]=satellite(varargin)

            switch length(varargin)

                %%
                case 0
                    self.pos=[];
                    self.vel=[];
                    self.ref=[];
                    self.epoch=[];

                    %%
                case 1
                    fileName=varargin{:};
                    [self.epoch, self.pos, self.vel] = satellite.read_binary_filefast(fileName);
                    self.ref='CRI';
                    %%
                case 3

                    self.epoch=varargin{1}(:);
                    if size(varargin{2},1)==3
                        self.pos=varargin{2}';
                    elseif size(varargin{2},2)==3
                        self.pos=varargin{2};
                    else
                        error('! satellite')
                    end
                    if size(varargin{3},1)==3
                        self.vel=varargin{3}';
                    elseif size(varargin{3},2)==3
                        self.vel=varargin{3};
                    else
                        error('! satellite')
                    end
                    self.ref='CRI';
            end

        end

        %%

        function [objnew] =copy(obj)
            nsol=length(obj);
            if nsol==1
                switch class(obj)
                    case 'satellite'
                        objnew=satellite();
                end
                temp=properties(obj);
                for k=1:length(temp)
                    objnew.(temp{k})=obj.(temp{k});
                end
            else
                for k=1:nsol
                    objnew(k)=obj(k).copy;
                end
            end
        end

        function objnew=plus(objl,objr)

            nl=length(objl);
            nr=length(objr);
            if nl==1&nr==1
                objnew=objl.copy;
                objnew.pos=objl.pos+objr.pos;
                objnew.vel=objl.vel+objr.vel;
            elseif nl==1&nr>1
                for k=1:nr
                    objnew(k)=objl+objr(k);
                end
            elseif nl>1&nr==1
                for k=1:nl
                    objnew(k)=objl(k)+objr;
                end
            elseif nl==nr&nl>1
                for k=1:nr
                    objnew(k)=objl(k)+objr(k);
                end
            end


        end

        function [objnew]=times(objl,objr)

            nl=length(objl);
            nr=length(objr);
            if nl==1&nr==1
                cl=isa(objl,'double');
                cr=isa(objr,'double');

                if cl==1
                    sc=objl;
                    tempobj=objr.copy();
                elseif cr==1
                    sc=objr;
                    tempobj=objl.copy();
                end

                objnew=tempobj.copy;
                objnew.pos=tempobj.pos*sc;
                objnew.vel=tempobj.vel*sc;
            elseif nl==1&nr>1
                for k=1:nr
                    objnew(k)=objl.*objr(k);
                end
            elseif nl>1&nr==1
                for k=1:nr
                    objnew(k)=objl(k).*objr;
                end
            elseif  nl==nr&nl>1
                for k=1:nr
                    objnew(k)=objl(k).*objr(k);
                end
            end
        end

        function objnew=minus(objl,objr)
            objnew=objl+(-1).*objr;
        end

        function [rmsinfo]=rms(obj)

            nsol=length(obj);
            for k=1:nsol
                obj(k).rmspos=rms(obj(k).pos,1);
                obj(k).rmsvel=rms(obj(k).vel,1);
                rmsinfo(k,:)=[obj(k).rmspos obj(k).rmsvel];
            end

        end


        %%
        % --------------------------
        function [idx]=get_idx(self,epoch)
            idx= find(self.epoch==epoch);
        end

        function [r]=get_pos(self,epoch)
            idx=self.get_idx(epoch);
            r  =self.pos(idx,:);
        end

        function [v]=get_vel(self,epoch)
            idx=self.get_idx(epoch);
            v  =self.vel(idx,:);
        end

        function [x]=getx(self,epoch)
            r=self.get_pos(epoch);
            x=r(1);
        end

        function [y]=gety(self,epoch)
            r=self.get_pos(epoch);
            y=r(2);
        end

        function [z]=getz(self,epoch)
            r=self.get_pos(epoch);
            z=r(3);
        end

        function [xe]=getxe(self,epoch)
            v=self.get_vel(epoch);
            xe=v(1);
        end

        function [ye]=getye(self,epoch)
            v=self.get_vel(epoch);
            ye=v(2);
        end

        function [ze]=getze(self,epoch)
            v=self.get_vel(epoch);
            ze=v(3);
        end
        %         function [objnew]=m
        %%
        function [h]=plotrabs(self)
            self.ramp=sqrt(sum(self.pos.^2,2));
            h=plot(self.epoch,self.ramp,'LineWidth',0.25);
        end


        function [h]=plotvabs(self)

            self.vamp=sqrt(sum(self.pos.^2,2));
            h=plot(self.epoch,self.vamp);

        end



        function [h]=plotpos(self,flag)

            nsol=length(self);
            if nsol==1
                
                colorf={'r','b','black'};
                str={'X [m]','Y [m]','Z [m]'};
                h=plot(self.epoch,self.pos(:,flag));
                h.LineWidth=0.25;
                h.Color=colorf{flag};
                xlabel('GPST [s]');
                ylabel(str{flag});
                xlim([self.epoch(1) self.epoch(end)])
                set(gca,'FontSize',12);
                
                

            else
                for k=1:nsol
                    h(k)=self(k).plotpos(flag);
                    hold on;
                end
            end
        end


        function [h]=plotvel(self,flag)
            str={'Xe [m/s]','Ye [m/s]','Z [m/s]'};

                colorf={'r','b','black'};
            nsol=length(self);
            if nsol==1
                h=plot(self.epoch,self.vel(:,flag));
                h.LineWidth=0.25;

                h.Color=colorf{flag};
                xlabel('GPST [s]');
                ylabel(str{flag});

                xlim([self.epoch(1) self.epoch(end)])
                set(gca,'FontSize',12);

            elseif nsol>1

                for k=1:nsol
                    h(k)=self(k).plotvel(flag);
                    hold on;
                end
            end
        end

    end

    methods(Static)


        function [nepo_array, start_pos_array, start_vel_array] = read_binary_filefast(fileName)
            % 以二进制只读模式打开文件
            fid = fopen(fileName, 'r');
            if fid == -1
                error('无法打开文件: %s', fileName);
            end

            % 预估数据大小，这里假设文件中数据项数量为 N
            % 你可以通过文件大小等信息更准确地预估 N

            N=17280*365;

            temp=fread(fid, N*7, 'double');
            fclose(fid);

            fid = fopen(fileName, 'r');
            N=length(temp)/7;
            temp=fread(fid, N*7, 'double');
            tempmat=reshape(temp,7,N)';


            nepo_array = zeros(N, 1);
            start_pos_array = zeros(N, 3);
            start_vel_array = zeros(N, 3);
            nepo_array=tempmat(:,1);
            start_pos_array=tempmat(:,2:4);
            start_vel_array=tempmat(:,5:7);

            % 关闭文件
            fclose(fid);


        end
        %%
        function [nepo_array, start_pos_array, start_vel_array] = read_binary_file(fileName)
            % 以二进制只读模式打开文件
            fid = fopen(fileName, 'r');
            if fid == -1
                error('无法打开文件: %s', fileName);
            end

            % 初始化存储数据的数组
            nepo_array = [];
            start_pos_array = [];
            start_vel_array = [];
            f=0;
            % 循环读取数据直到文件末尾
            while ~feof(fid)
                f=f+1
                % 读取 nepo（一个双精度浮点数）
                nepo = fread(fid, 1, 'double');
                % 读取 start_pos（长度为 3 的双精度向量）
                start_pos = fread(fid, 3, 'double');
                % 读取 start_vel（长度为 3 的双精度向量）
                start_vel = fread(fid, 3, 'double');

                % 将读取的数据添加到数组中
                nepo_array = [nepo_array; nepo];
                start_pos_array = [start_pos_array; start_pos'];
                start_vel_array = [start_vel_array; start_vel'];
            end

            % 关闭文件
            fclose(fid);
        end


    end

end